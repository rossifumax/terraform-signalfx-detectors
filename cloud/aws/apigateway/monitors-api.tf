resource "signalfx_detector" "heartbeat" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] AWS ApiGateway heartbeat"

	program_text = <<-EOF
		from signalfx.detectors.not_reporting import not_reporting
		signal = data('IntegrationLatency', filter=filter('stat', 'mean') and filter('namespace', 'AWS/ApiGateway') and ${module.filter-tags.filter_custom})
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

# Monitoring Api Gateway latency
resource "signalfx_detector" "latency" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] ApiGateway latency"

	program_text = <<-EOF
		signal = data('Latency', filter=filter('namespace', 'AWS/ApiGateway') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.latency_aggregation_function}.${var.latency_transformation_function}(over='${var.latency_transformation_window}')
		detect(when(signal > ${var.latency_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.latency_threshold_warning})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.latency_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.latency_disabled_critical, var.latency_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.latency_notifications_critical, var.latency_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.latency_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.latency_disabled_warning, var.latency_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.latency_notifications_warning, var.latency_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

# Monitoring API Gateway 5xx errors percent
resource "signalfx_detector" "http_5xx_errors_count" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] ApiGateway HTTP 5xx errors"

	program_text = <<-EOF
		A = data('5XXError', filter=filter('namespace', 'AWS/ApiGateway') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.http_5xx_errors_aggregation_function}
		B = data('Count', filter=filter('namespace', 'AWS/ApiGateway'), extrapolation='zero', rollup='rate')${var.http_5xx_errors_aggregation_function}
		signal = (A/(B+5)).scale(100).${var.http_5xx_errors_transformation_function}(over='${var.http_5xx_errors_transformation_window}')
		detect(when(signal > ${var.http_5xx_errors_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.http_5xx_errors_threshold_warning})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.http_5xx_errors_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.http_5xx_errors_disabled_critical, var.http_5xx_errors_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.http_5xx_errors_notifications_critical, var.http_5xx_errors_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.http_5xx_errors_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.http_5xx_errors_disabled_warning, var.http_5xx_errors_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.http_5xx_errors_notifications_warning, var.http_5xx_errors_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

# Monitoring API Gateway 4xx errors percent
resource "signalfx_detector" "http_4xx_errors_count" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] ApiGateway HTTP 4xx errors"

	program_text = <<-EOF
		A = data('4XXError', filter=filter('namespace', 'AWS/ApiGateway') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.http_4xx_errors_aggregation_function}
		B = data('Count', filter=filter('namespace', 'AWS/ApiGateway') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.http_4xx_errors_aggregation_function}
		signal = (A/(B+5)).scale(100).${var.http_5xx_errors_transformation_function}(over='${var.http_5xx_errors_transformation_window}')
		detect(when(signal > ${var.http_4xx_errors_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.http_4xx_errors_threshold_warning})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.http_4xx_errors_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.http_4xx_errors_disabled_critical, var.http_4xx_errors_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.http_4xx_errors_notifications_critical, var.http_4xx_errors_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.http_4xx_errors_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.http_4xx_errors_disabled_warning, var.http_4xx_errors_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.http_4xx_errors_notifications_warning, var.http_4xx_errors_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}
