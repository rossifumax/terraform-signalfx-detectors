resource "signalfx_detector" "heartbeat" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] AWS lambda heartbeat"

	program_text = <<-EOF
		from signalfx.detectors.not_reporting import not_reporting
		signal = data('Duration', filter=filter('stat', 'count') and filter('namespace', 'AWS/Lambda') and ${module.filter-tags.filter_custom})
		not_reporting.detector(stream=signal, resource_identifier=['host'], duration='${var.heartbeat_timeframe}').publish('CRIT')
	EOF

	rule {
		description           = "has not reported in ${var.heartbeat_timeframe}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.heartbeat_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.heartbeat_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} on {{{dimensions}}}"
	}
}

resource "signalfx_detector" "pct_errors" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Lambda Percentage of errors"

	program_text = <<-EOF
		A = data('Errors', filter=filter('namespace', 'AWS/Lambda') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.pct_errors_aggregation_function}
		B = data('Invocations', filter=filter('namespace', 'AWS/Lambda') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.pct_errors_aggregation_function}
		signal = (A/B).scale(100).${var.pct_errors_transformation_function}(over='${var.pct_errors_transformation_window}')
		detect(when(signal > ${var.pct_errors_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.pct_errors_threshold_warning})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.pct_errors_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.pct_errors_disabled_critical, var.pct_errors_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.pct_errors_notifications_critical, var.pct_errors_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.pct_errors_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.pct_errors_disabled_warning, var.pct_errors_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.pct_errors_notifications_warning, var.pct_errors_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "errors" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Lambda Number of errors"

	program_text = <<-EOF
		signal = data('Errors', filter=filter('namespace', 'AWS/Lambda') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.errors_aggregation_function}.${var.errors_transformation_function}(over='${var.errors_transformation_window}')
		detect(when(signal > ${var.errors_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.errors_threshold_warning})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.errors_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.errors_disabled_critical, var.errors_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.errors_notifications_critical, var.errors_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.errors_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.errors_disabled_warning, var.errors_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.errors_notifications_warning, var.errors_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "throttles" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Lambda invocations throttled"

	program_text = <<-EOF
		signal = data('Throttles', filter=filter('namespace', 'AWS/Lambda') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.throttles_aggregation_function}.${var.throttles_transformation_function}(over='${var.throttles_transformation_window}')
		detect(when(signal > ${var.throttles_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.throttles_threshold_warning})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.throttles_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.throttles_disabled_critical, var.throttles_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.throttles_notifications_critical, var.throttles_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.throttles_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.throttles_disabled_warning, var.throttles_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.throttles_notifications_warning, var.throttles_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "invocations" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Lambda number of invocations"

	program_text = <<-EOF
		signal = data('Invocations', filter=filter('namespace', 'AWS/Lambda') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.invocations_aggregation_function}.${var.invocations_transformation_function}(over='${var.invocations_transformation_window}')
		detect(when(signal <= ${var.invocations_threshold_critical})).publish('CRIT')
		detect(when(signal <= ${var.invocations_threshold_warning})).publish('WARN')
	EOF

	rule {
		description           = "is too low <= ${var.invocations_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.invocations_disabled_critical, var.invocations_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.invocations_notifications_critical, var.invocations_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too low <= ${var.invocations_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.invocations_disabled_warning, var.invocations_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.invocations_notifications_warning, var.invocations_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}
