resource "signalfx_detector" "heartbeat" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] AWS ECS cluster heartbeat"

	program_text = <<-EOF
		from signalfx.detectors.not_reporting import not_reporting
		signal = data('CPUReservation', filter=filter('stat', 'mean') and filter('namespace', 'AWS/ECS') and not filter('ServiceName', '*') and ${module.filter-tags.filter_custom})
		not_reporting.detector(stream=signal, resource_identifier=['ClusterName'], duration='${var.heartbeat_timeframe}').publish('CRIT')
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

resource "signalfx_detector" "cpu_utilization" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] AWS ECS cluster CPU utilization"

	program_text = <<-EOF
		signal = data('CPUUtilization', filter=filter('namespace', 'AWS/ECS')) and filter('stat', 'mean') and not filter('ServiceName', '*') and ${module.filter-tags.filter_custom}).mean(by=['ClusterName'])${var.cpu_utilization_aggregation_function}.${var.cpu_utilization_transformation_function}(over='${var.cpu_utilization_transformation_window}')
		detect(when(signal > ${var.cpu_utilization_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.cpu_utilization_threshold_warning})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.cpu_utilization_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.cpu_utilization_disabled_critical, var.cpu_utilization_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.cpu_utilization_notifications_critical, var.cpu_utilization_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.cpu_utilization_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.cpu_utilization_disabled_warning, var.cpu_utilization_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.cpu_utilization_notifications_warning, var.cpu_utilization_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "memory_reservation" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] AWS ECS cluster memory reservation"

	program_text = <<-EOF
		signal = data('MemoryReservation', filter=filter('namespace', 'AWS/ECS') and filter('stat', 'mean') and not filter('ServiceName', '*') and ${module.filter-tags.filter_custom}).mean(by=['ClusterName'])${var.memory_reservation_aggregation_function}.${var.memory_reservation_transformation_function}(over='${var.memory_reservation_transformation_window}')
		detect(when(signal > ${var.memory_reservation_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.memory_reservation_threshold_warning})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.memory_reservation_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.memory_reservation_disabled_critical, var.memory_reservation_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.memory_reservation_notifications_critical, var.memory_reservation_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.memory_reservation_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.memory_reservation_disabled_warning, var.memory_reservation_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.memory_reservation_notifications_warning, var.memory_reservation_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}
