resource "signalfx_detector" "heartbeat" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] AWS ELB heartbeat"

	program_text = <<-EOF
		from signalfx.detectors.not_reporting import not_reporting
		signal = data('RequestCount', filter=filter('stat', 'sum') and filter('namespace', 'AWS/ELB') and ${module.filter-tags.filter_custom})
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

resource "signalfx_detector" "no_healthy_instances" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] ELB healthy instances"

	program_text = <<-EOF
		A = data('HealthyHostCount', filter=filter('namespace', 'AWS/ELB') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.no_healthy_instances_aggregation_function})
		B = data('UnHealthyHostCount', filter=filter('namespace', 'AWS/ELB') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.no_healthy_instances_aggregation_function})
		signal = (A/ (A + B)).scale(100).${var.no_healthy_instances_transformation_function}(over='${var.no_healthy_instances_transformation_window}')
		detect(when(signal < ${var.no_healthy_instances_threshold_critical})).publish('CRIT')
		detect(when(signal < ${var.no_healthy_instances_threshold_warning})).publish('WARN')
	EOF

	rule {
		description           = "is too low < ${var.no_healthy_instances_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.no_healthy_instances_disabled_critical, var.no_healthy_instances_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.no_healthy_instances_notifications_critical, var.no_healthy_instances_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too low < ${var.no_healthy_instances_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.no_healthy_instances_disabled_warning, var.no_healthy_instances_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.no_healthy_instances_notifications_warning, var.no_healthy_instances_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "too_much_4xx" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] ELB 4xx errors"

	program_text = <<-EOF
		A = data('HTTPCode_ELB_4XX', filter=filter('namespace', 'AWS/ELB') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.too_much_4xx_aggregation_function}
		B = data('RequestCount', filter=filter('namespace', 'AWS/ELB') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.too_much_4xx_aggregation_function}
		signal = (A/ (B + 5)).scale(100).${var.too_much_4xx_transformation_function}(over='${var.too_much_4xx_transformation_window}')
		detect(when(signal > ${var.too_much_4xx_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.too_much_4xx_threshold_warning})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.too_much_4xx_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.too_much_4xx_disabled_critical, var.too_much_4xx_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.too_much_4xx_notifications_critical, var.too_much_4xx_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.too_much_4xx_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.too_much_4xx_disabled_warning, var.too_much_4xx_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.too_much_4xx_notifications_warning, var.too_much_4xx_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "too_much_5xx" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] ELB 5xx errors"

	program_text = <<-EOF
		A = data('HTTPCode_ELB_5XX', filter=filter('namespace', 'AWS/ELB') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.too_much_5xx_aggregation_function}
		B = data('RequestCount', filter=filter('namespace', 'AWS/ELB') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.too_much_5xx_aggregation_function}
		signal = (A/ (B + 5)).scale(100).${var.too_much_5xx_transformation_function}(over='${var.too_much_5xx_transformation_window}')
		detect(when(signal > ${var.too_much_5xx_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.too_much_5xx_threshold_warning})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.too_much_5xx_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.too_much_5xx_disabled_critical, var.too_much_5xx_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.too_much_5xx_notifications_critical, var.too_much_5xx_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.too_much_5xx_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.too_much_5xx_disabled_warning, var.too_much_5xx_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.too_much_5xx_notifications_warning, var.too_much_5xx_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "too_much_4xx_backend" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] ELB backend 4xx errors"

	program_text = <<-EOF
		A = data('HTTPCode_Backend_4XX', filter=filter('namespace', 'AWS/ELB') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.too_much_4xx_backend_aggregation_function}
		B = data('RequestCount', filter=filter('namespace', 'AWS/ELB') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.too_much_4xx_backend_aggregation_function}
		signal = (A/ (B + 5)).scale(100).${var.too_much_4xx_backend_transformation_function}(over='${var.too_much_4xx_backend_transformation_window}')
		detect(when(signal > ${var.too_much_4xx_backend_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.too_much_4xx_backend_threshold_warning})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.too_much_4xx_backend_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.too_much_4xx_backend_disabled_critical, var.too_much_4xx_backend_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.too_much_4xx_backend_notifications_critical, var.too_much_4xx_backend_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.too_much_4xx_backend_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.too_much_4xx_backend_disabled_warning, var.too_much_4xx_backend_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.too_much_4xx_backend_notifications_warning, var.too_much_4xx_backend_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "too_much_5xx_backend" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] ELB backend 5xx errors"

	program_text = <<-EOF
		A = data('HTTPCode_Backend_5XX', filter=filter('namespace', 'AWS/ELB') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.too_much_5xx_backend_aggregation_function}
		B = data('RequestCount', filter=filter('namespace', 'AWS/ELB') and filter('stat', 'sum') and ${module.filter-tags.filter_custom})${var.too_much_5xx_backend_aggregation_function}
		signal = (A/ (B + 5)).scale(100).${var.too_much_5xx_backend_transformation_function}(over='${var.too_much_5xx_backend_transformation_window}')
		detect(when(signal > ${var.too_much_5xx_backend_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.too_much_5xx_backend_threshold_warning})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.too_much_5xx_backend_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.too_much_5xx_backend_disabled_critical, var.too_much_5xx_backend_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.too_much_5xx_backend_notifications_critical, var.too_much_5xx_backend_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.too_much_5xx_backend_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.too_much_5xx_backend_disabled_warning, var.too_much_5xx_backend_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.too_much_5xx_backend_notifications_warning, var.too_much_5xx_backend_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "backend_latency" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] ELB backend latency"

	program_text = <<-EOF
		signal = data('Latency', filter=filter('namespace', 'AWS/ELB') and filter('stat', 'mean') and ${module.filter-tags.filter_custom})${var.backend_latency_aggregation_function}.${var.backend_latency_transformation_function}(over='${var.backend_latency_transformation_window}')
		detect(when(signal > ${var.backend_latency_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.backend_latency_threshold_warning})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.backend_latency_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.backend_latency_disabled_critical, var.backend_latency_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.backend_latency_notifications_critical, var.backend_latency_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.backend_latency_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.backend_latency_disabled_warning, var.backend_latency_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.backend_latency_notifications_warning, var.backend_latency_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}
