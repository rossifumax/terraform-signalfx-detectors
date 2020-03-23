resource "signalfx_detector" "cpu_utilization" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Cloud SQL CPU utilization"

	program_text = <<-EOF
		A = data('database/cpu/utilization' and ${module.filter-tags.filter_custom})${var.cpu_utilization_aggregation_function}
		signal = (A*100).${var.cpu_utilization_transformation_function}(over='${var.cpu_utilization_transformation_window}')
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

resource "signalfx_detector" "disk_utilization" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Cloud SQL disk utilization"

	program_text = <<-EOF
		A = data('database/disk/utilization' and ${module.filter-tags.filter_custom})${var.disk_utilization_aggregation_function}
		signal = (A*100).${var.disk_utilization_transformation_function}(over='${var.disk_utilization_transformation_window}')
		detect(when(signal > ${var.disk_utilization_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.disk_utilization_threshold_warning})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.disk_utilization_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.disk_utilization_disabled_critical, var.disk_utilization_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.disk_utilization_notifications_critical, var.disk_utilization_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.disk_utilization_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.disk_utilization_disabled_warning, var.disk_utilization_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.disk_utilization_notifications_warning, var.disk_utilization_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}
}

resource "signalfx_detector" "memory_utilization" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Cloud SQL memory utilization"

	program_text = <<-EOF
		A = data('database/memory/utilization' and ${module.filter-tags.filter_custom})${var.memory_utilization_aggregation_function}
		signal = (A*100).${var.memory_utilization_transformation_function}(over='${var.memory_utilization_transformation_window}')
		detect(when(signal > ${var.memory_utilization_threshold_critical})).publish('CRIT')
		detect(when(signal > ${var.memory_utilization_threshold_warning})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.memory_utilization_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.memory_utilization_disabled_critical, var.memory_utilization_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.memory_utilization_notifications_critical, var.memory_utilization_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.memory_utilization_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.memory_utilization_disabled_warning, var.memory_utilization_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.memory_utilization_notifications_warning, var.memory_utilization_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}
}

resource "signalfx_detector" "failover_unavailable" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Cloud SQL failover unavailable"

	program_text = <<-EOF
		signal = data('database/available_for_failover' and ${module.filter-tags.filter_custom})${var.failover_unavailable_aggregation_function}.${var.failover_unavailable_transformation_function}(over='${var.failover_unavailable_transformation_window}')
		detect(when(signal <= ${var.failover_unavailable_threshold_critical})).publish('CRIT')
		detect(when(signal <= ${var.failover_unavailable_threshold_warning})).publish('WARN')
	EOF

	rule {
		description           = "is too low <= ${var.failover_unavailable_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.failover_unavailable_disabled_critical, var.failover_unavailable_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.failover_unavailable_notifications_critical, var.failover_unavailable_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too low <= ${var.failover_unavailable_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.failover_unavailable_disabled_warning, var.failover_unavailable_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.failover_unavailable_notifications_warning, var.failover_unavailable_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}
}
