resource "signalfx_detector" "heartbeat" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage heartbeat"

	program_text = <<-EOF
		from signalfx.detectors.not_reporting import not_reporting
		signal = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts') and ${module.filter-tags.filter_custom}).publish('signal')
		not_reporting.detector(stream=signal, resource_identifier=['ApiName'], duration='${var.heartbeat_timeframe}').publish('CRIT')
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

resource "signalfx_detector" "blobservices_requests_error" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage blob service error requests"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/blobServices') and filter('responsetype', 'Success') and (not filter('apiname', 'GetBlobProperties')) and (not filter('apiname', 'CreateContainer') and ${module.filter-tags.filter_custom})${var.blobservices_requests_error_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/blobServices') and (not filter('apiname', 'GetBlobProperties')) and (not filter('apiname', 'CreateContainer') and ${module.filter-tags.filter_custom})${var.blobservices_requests_error_aggregation_function}
		signal = (100-(A/B)).scale(100).${var.blobservices_requests_error_transformation_function}(over='${var.blobservices_requests_error_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.blobservices_requests_error_threshold_critical}, ‘above’, lasting('${var.blobservices_requests_error_aperiodic_duration}', ${var.blobservices_requests_error_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.blobservices_requests_error_threshold_warning}, ‘above’, lasting('${var.blobservices_requests_error_aperiodic_duration}', ${var.blobservices_requests_error_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.blobservices_requests_error_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.blobservices_requests_error_disabled_critical, var.blobservices_requests_error_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.blobservices_requests_error_notifications_critical, var.blobservices_requests_error_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.blobservices_requests_error_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.blobservices_requests_error_disabled_warning, var.blobservices_requests_error_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.blobservices_requests_error_notifications_warning, var.blobservices_requests_error_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "fileservices_requests_error" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage file service error requests"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/fileServices') and filter('responsetype', 'Success') and ${module.filter-tags.filter_custom})${var.fileservices_requests_error_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/fileServices') and ${module.filter-tags.filter_custom})${var.fileservices_requests_error_aggregation_function}
		signal = (100-(A/B)).scale(100).${var.fileservices_requests_error_transformation_function}(over='${var.fileservices_requests_error_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.fileservices_requests_error_threshold_critical}, ‘above’, lasting('${var.fileservices_requests_error_aperiodic_duration}', ${var.fileservices_requests_error_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.fileservices_requests_error_threshold_warning}, ‘above’, lasting('${var.fileservices_requests_error_aperiodic_duration}', ${var.fileservices_requests_error_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.fileservices_requests_error_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.fileservices_requests_error_disabled_critical, var.fileservices_requests_error_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.fileservices_requests_error_notifications_critical, var.fileservices_requests_error_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.fileservices_requests_error_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.fileservices_requests_error_disabled_warning, var.fileservices_requests_error_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.fileservices_requests_error_notifications_warning, var.fileservices_requests_error_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "queueservices_requests_error" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage queue service error requests"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/queueServices') and filter('responsetype', 'Success') and ${module.filter-tags.filter_custom})${var.queueservices_requests_error_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/queueServices') and ${module.filter-tags.filter_custom})${var.queueservices_requests_error_aggregation_function}
		signal = (100-(A/B)).scale(100).${var.queueservices_requests_error_transformation_function}(over='${var.queueservices_requests_error_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.queueservices_requests_error_threshold_critical}, ‘above’, lasting('${var.queueservices_requests_error_aperiodic_duration}', ${var.queueservices_requests_error_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.queueservices_requests_error_threshold_warning}, ‘above’, lasting('${var.queueservices_requests_error_aperiodic_duration}', ${var.queueservices_requests_error_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.queueservices_requests_error_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.queueservices_requests_error_disabled_critical, var.queueservices_requests_error_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.queueservices_requests_error_notifications_critical, var.queueservices_requests_error_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.queueservices_requests_error_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.queueservices_requests_error_disabled_warning, var.queueservices_requests_error_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.queueservices_requests_error_notifications_warning, var.queueservices_requests_error_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "tableservices_requests_error" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage table service error requests"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/tableServices') and filter('responsetype', 'Success') and ${module.filter-tags.filter_custom})${var.tableservices_requests_error_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/tableServices') and ${module.filter-tags.filter_custom})${var.tableservices_requests_error_aggregation_function}
		signal = (100-(A/B)).scale(100).${var.tableservices_requests_error_transformation_function}(over='${var.tableservices_requests_error_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.tableservices_requests_error_threshold_critical}, ‘above’, lasting('${var.tableservices_requests_error_aperiodic_duration}', ${var.tableservices_requests_error_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.tableservices_requests_error_threshold_warning}, ‘above’, lasting('${var.tableservices_requests_error_aperiodic_duration}', ${var.tableservices_requests_error_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.tableservices_requests_error_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.tableservices_requests_error_disabled_critical, var.tableservices_requests_error_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.tableservices_requests_error_notifications_critical, var.tableservices_requests_error_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.tableservices_requests_error_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.tableservices_requests_error_disabled_warning, var.tableservices_requests_error_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.tableservices_requests_error_notifications_warning, var.tableservices_requests_error_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "blobservices_latency" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage blob service latency"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		signal = data('SuccessE2ELatency', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/blobServices') and ${module.filter-tags.filter_custom})${var.blobservices_latency_aggregation_function}.${var.blobservices_latency_transformation_function}(over='${var.blobservices_latency_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.blobservices_latency_threshold_critical}, ‘above’, lasting('${var.blobservices_latency_aperiodic_duration}', ${var.blobservices_latency_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.blobservices_latency_threshold_warning}, ‘above’, lasting('${var.blobservices_latency_aperiodic_duration}', ${var.blobservices_latency_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.blobservices_latency_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.blobservices_latency_disabled_critical, var.blobservices_latency_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.blobservices_latency_notifications_critical, var.blobservices_latency_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.blobservices_latency_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.blobservices_latency_disabled_warning, var.blobservices_latency_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.blobservices_latency_notifications_warning, var.blobservices_latency_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "fileservices_latency" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage file service latency"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		signal = data('SuccessE2ELatency', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/fileServices') and ${module.filter-tags.filter_custom})${var.fileservices_latency_aggregation_function}.${var.fileservices_latency_transformation_function}(over='${var.fileservices_latency_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.fileservices_latency_threshold_critical}, ‘above’, lasting('${var.fileservices_latency_aperiodic_duration}', ${var.fileservices_latency_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.fileservices_latency_threshold_warning}, ‘above’, lasting('${var.fileservices_latency_aperiodic_duration}', ${var.fileservices_latency_aperiodic_percentage})).publish('WARN')
    EOF

	rule {
		description           = "is too high > ${var.fileservices_latency_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.fileservices_latency_disabled_critical, var.fileservices_latency_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.fileservices_latency_notifications_critical, var.fileservices_latency_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.fileservices_latency_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.fileservices_latency_disabled_warning, var.fileservices_latency_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.fileservices_latency_notifications_warning, var.fileservices_latency_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "queueservices_latency" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage queue service latency"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		signal = data('SuccessE2ELatency', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/queueServices') and ${module.filter-tags.filter_custom})${var.queueservices_latency_aggregation_function}.${var.queueservices_latency_transformation_function}(over='${var.queueservices_latency_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.queueservices_latency_threshold_critical}, ‘above’, lasting('${var.queueservices_latency_aperiodic_duration}', ${var.queueservices_latency_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.queueservices_latency_threshold_warning}, ‘above’, lasting('${var.queueservices_latency_aperiodic_duration}', ${var.queueservices_latency_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.queueservices_latency_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.queueservices_latency_disabled_critical, var.queueservices_latency_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.queueservices_latency_notifications_critical, var.queueservices_latency_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.queueservices_latency_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.queueservices_latency_disabled_warning, var.queueservices_latency_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.queueservices_latency_notifications_warning, var.queueservices_latency_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "tableservices_latency" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage table service latency"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		signal = data('SuccessE2ELatency', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/tableServices') and ${module.filter-tags.filter_custom}){var.tableservices_latency_aggregation_function}.${var.tableservices_latency_transformation_function}(over='${var.tableservices_latency_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.tableservices_latency_threshold_critical}, ‘above’, lasting('${var.tableservices_latency_aperiodic_duration}', ${var.tableservices_latency_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.tableservices_latency_threshold_warning}, ‘above’, lasting('${var.tableservices_latency_aperiodic_duration}', ${var.tableservices_latency_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.tableservices_latency_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.tableservices_latency_disabled_critical, var.tableservices_latency_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.tableservices_latency_notifications_critical, var.tableservices_latency_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.tableservices_latency_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.tableservices_latency_disabled_warning, var.tableservices_latency_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.tableservices_latency_notifications_warning, var.tableservices_latency_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "blob_timeout_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage blob timeout errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/blobServices') and filter('responsetype', 'ServerTimeoutError') and ${module.filter-tags.filter_custom}){var.blob_timeout_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/blobServices') and ${module.filter-tags.filter_custom}){var.blob_timeout_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.blob_timeout_error_requests_transformation_function}(over='${var.blob_timeout_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.blob_timeout_error_requests_threshold_critical}, ‘above’, lasting('${var.blob_timeout_error_requests_aperiodic_duration}', ${var.blob_timeout_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.blob_timeout_error_requests_threshold_warning}, ‘above’, lasting('${var.blob_timeout_error_requests_aperiodic_duration}', ${var.blob_timeout_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.blob_timeout_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.blob_timeout_error_requests_disabled_critical, var.blob_timeout_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.blob_timeout_error_requests_notifications_critical, var.blob_timeout_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.blob_timeout_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.blob_timeout_error_requests_disabled_warning, var.blob_timeout_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.blob_timeout_error_requests_notifications_warning, var.blob_timeout_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "file_timeout_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage file timeout errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/fileServices') and filter('responsetype', 'ServerTimeoutError') and ${module.filter-tags.filter_custom}){var.file_timeout_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/fileServices') and filter('apiname', 'GetFileServiceProperties') and ${module.filter-tags.filter_custom}){var.file_timeout_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.file_timeout_error_requests_transformation_function}(over='${var.file_timeout_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.file_timeout_error_requests_threshold_critical}, ‘above’, lasting('${var.file_timeout_error_requests_aperiodic_duration}', ${var.file_timeout_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.file_timeout_error_requests_threshold_warning}, ‘above’, lasting('${var.file_timeout_error_requests_aperiodic_duration}', ${var.file_timeout_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.file_timeout_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.file_timeout_error_requests_disabled_critical, var.file_timeout_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.file_timeout_error_requests_notifications_critical, var.file_timeout_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.file_timeout_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.file_timeout_error_requests_disabled_warning, var.file_timeout_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.file_timeout_error_requests_notifications_warning, var.file_timeout_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "queue_timeout_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage queue timeout errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/queueServices') and filter('responsetype', 'ServerTimeoutError') and ${module.filter-tags.filter_custom})${var.queue_timeout_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/queueServices') and ${module.filter-tags.filter_custom})${var.queue_timeout_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.queue_timeout_error_requests_transformation_function}(over='${var.queue_timeout_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.queue_timeout_error_requests_threshold_critical}, ‘above’, lasting('${var.queue_timeout_error_requests_aperiodic_duration}', ${var.queue_timeout_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.queue_timeout_error_requests_threshold_warning}, ‘above’, lasting('${var.queue_timeout_error_requests_aperiodic_duration}', ${var.queue_timeout_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.queue_timeout_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.queue_timeout_error_requests_disabled_critical, var.queue_timeout_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.queue_timeout_error_requests_notifications_critical, var.queue_timeout_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.queue_timeout_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.queue_timeout_error_requests_disabled_warning, var.queue_timeout_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.queue_timeout_error_requests_notifications_warning, var.queue_timeout_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "table_timeout_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage table timeout errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/tableServices') and filter('responsetype', 'ServerTimeoutError') and ${module.filter-tags.filter_custom})${var.table_timeout_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/tableServices') and ${module.filter-tags.filter_custom})${var.table_timeout_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.table_timeout_error_requests_transformation_function}(over='${var.table_timeout_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.table_timeout_error_requests_threshold_critical}, ‘above’, lasting('${var.table_timeout_error_requests_aperiodic_duration}', ${var.table_timeout_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.table_timeout_error_requests_threshold_warning}, ‘above’, lasting('${var.table_timeout_error_requests_aperiodic_duration}', ${var.table_timeout_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.table_timeout_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.table_timeout_error_requests_disabled_critical, var.table_timeout_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.table_timeout_error_requests_notifications_critical, var.table_timeout_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.table_timeout_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.table_timeout_error_requests_disabled_warning, var.table_timeout_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.table_timeout_error_requests_notifications_warning, var.table_timeout_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "blob_network_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage blob network errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/blobServices') and filter('responsetype', 'NetworkError') and ${module.filter-tags.filter_custom})${var.blob_network_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/blobServices') and ${module.filter-tags.filter_custom})${var.blob_network_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.blob_network_error_requests_transformation_function}(over='${var.blob_network_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.blob_network_error_requests_threshold_critical}, ‘above’, lasting('${var.blob_network_error_requests_aperiodic_duration}', ${var.blob_network_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.blob_network_error_requests_threshold_warning}, ‘above’, lasting('${var.blob_network_error_requests_aperiodic_duration}', ${var.blob_network_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.blob_network_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.blob_network_error_requests_disabled_critical, var.blob_network_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.blob_network_error_requests_notifications_critical, var.blob_network_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.blob_network_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.blob_network_error_requests_disabled_warning, var.blob_network_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.blob_network_error_requests_notifications_warning, var.blob_network_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "file_network_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage file network errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/fileServices') and filter('responsetype', 'NetworkError') and ${module.filter-tags.filter_custom})${var.file_network_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/fileServices') and ${module.filter-tags.filter_custom})${var.file_network_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.file_network_error_requests_transformation_function}(over='${var.file_network_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.file_network_error_requests_threshold_critical}, ‘above’, lasting('${var.file_network_error_requests_aperiodic_duration}', ${var.file_network_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.file_network_error_requests_threshold_warning}, ‘above’, lasting('${var.file_network_error_requests_aperiodic_duration}', ${var.file_network_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.file_network_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.file_network_error_requests_disabled_critical, var.file_network_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.file_network_error_requests_notifications_critical, var.file_network_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.file_network_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.file_network_error_requests_disabled_warning, var.file_network_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.file_network_error_requests_notifications_warning, var.file_network_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "queue_network_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage queue network errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/queueServices') and filter('responsetype', 'NetworkError') and ${module.filter-tags.filter_custom})${var.queue_network_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/queueServices') and ${module.filter-tags.filter_custom})${var.queue_network_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.queue_network_error_requests_transformation_function}(over='${var.queue_network_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.queue_network_error_requests_threshold_critical}, ‘above’, lasting('${var.queue_network_error_requests_aperiodic_duration}', ${var.queue_network_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.queue_network_error_requests_threshold_warning}, ‘above’, lasting('${var.queue_network_error_requests_aperiodic_duration}', ${var.queue_network_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.queue_network_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.queue_network_error_requests_disabled_critical, var.queue_network_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.queue_network_error_requests_notifications_critical, var.queue_network_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.queue_network_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.queue_network_error_requests_disabled_warning, var.queue_network_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.queue_network_error_requests_notifications_warning, var.queue_network_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "table_network_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage table network errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/tableServices') and filter('responsetype', 'NetworkError') and ${module.filter-tags.filter_custom})${var.table_network_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/tableServices') and ${module.filter-tags.filter_custom})${var.table_network_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.table_network_error_requests_transformation_function}(over='${var.table_network_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.table_network_error_requests_threshold_critical}, ‘above’, lasting('${var.table_network_error_requests_aperiodic_duration}', ${var.table_network_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.table_network_error_requests_threshold_warning}, ‘above’, lasting('${var.table_network_error_requests_aperiodic_duration}', ${var.table_network_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

rule {
		description           = "is too high > ${var.table_network_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.table_network_error_requests_disabled_critical, var.table_network_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.table_network_error_requests_notifications_critical, var.table_network_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.table_network_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.table_network_error_requests_disabled_warning, var.table_network_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.table_network_error_requests_notifications_warning, var.table_network_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "blob_throttling_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage blob throttling errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/blobServices') and filter('responsetype', 'ServerBusyError') and ${module.filter-tags.filter_custom})${var.blob_throttling_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/blobServices') and ${module.filter-tags.filter_custom})${var.blob_throttling_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.blob_throttling_error_requests_transformation_function}(over='${var.blob_throttling_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.blob_throttling_error_requests_threshold_critical}, ‘above’, lasting('${var.blob_throttling_error_requests_aperiodic_duration}', ${var.blob_throttling_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.blob_throttling_error_requests_threshold_warning}, ‘above’, lasting('${var.blob_throttling_error_requests_aperiodic_duration}', ${var.blob_throttling_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.blob_throttling_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.blob_throttling_error_requests_disabled_critical, var.blob_throttling_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.blob_throttling_error_requests_notifications_critical, var.blob_throttling_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.blob_throttling_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.blob_throttling_error_requests_disabled_warning, var.blob_throttling_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.blob_throttling_error_requests_notifications_warning, var.blob_throttling_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "file_throttling_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage file throttling errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/fileServices') and filter('responsetype', 'ServerBusyError') and ${module.filter-tags.filter_custom})${var.file_throttling_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/fileServices') and ${module.filter-tags.filter_custom})${var.file_throttling_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.file_throttling_error_requests_transformation_function}(over='${var.file_throttling_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.file_throttling_error_requests_threshold_critical}, ‘above’, lasting('${var.file_throttling_error_requests_aperiodic_duration}', ${var.file_throttling_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.file_throttling_error_requests_threshold_warning}, ‘above’, lasting('${var.file_throttling_error_requests_aperiodic_duration}', ${var.file_throttling_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.file_throttling_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.file_throttling_error_requests_disabled_critical, var.file_throttling_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.file_throttling_error_requests_notifications_critical, var.file_throttling_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.file_throttling_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.file_throttling_error_requests_disabled_warning, var.file_throttling_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.file_throttling_error_requests_notifications_warning, var.file_throttling_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "queue_throttling_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage queue throttling errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/queueServices') and filter('responsetype', 'ServerBusyError') and ${module.filter-tags.filter_custom})${var.queue_throttling_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/queueServices') and ${module.filter-tags.filter_custom})${var.queue_throttling_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.queue_throttling_error_requests_transformation_function}(over='${var.queue_throttling_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.queue_throttling_error_requests_threshold_critical}, ‘above’, lasting('${var.queue_throttling_error_requests_aperiodic_duration}', ${var.queue_throttling_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.queue_throttling_error_requests_threshold_warning}, ‘above’, lasting('${var.queue_throttling_error_requests_aperiodic_duration}', ${var.queue_throttling_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.queue_throttling_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.queue_throttling_error_requests_disabled_critical, var.queue_throttling_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.queue_throttling_error_requests_notifications_critical, var.queue_throttling_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.queue_throttling_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.queue_throttling_error_requests_disabled_warning, var.queue_throttling_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.queue_throttling_error_requests_notifications_warning, var.queue_throttling_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "table_throttling_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage table throttling errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/tableServices') and filter('responsetype', 'ServerBusyError') and ${module.filter-tags.filter_custom})${var.table_throttling_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/tableServices') and ${module.filter-tags.filter_custom})${var.table_throttling_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.table_throttling_error_requests_transformation_function}(over='${var.table_throttling_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.table_throttling_error_requests_threshold_critical}, ‘above’, lasting('${var.table_throttling_error_requests_aperiodic_duration}', ${var.table_throttling_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.table_throttling_error_requests_threshold_warning}, ‘above’, lasting('${var.table_throttling_error_requests_aperiodic_duration}', ${var.table_throttling_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.table_throttling_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.table_throttling_error_requests_disabled_critical, var.table_throttling_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.table_throttling_error_requests_notifications_critical, var.table_throttling_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.table_throttling_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.table_throttling_error_requests_disabled_warning, var.table_throttling_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.table_throttling_error_requests_notifications_warning, var.table_throttling_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "blob_server_other_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage blob server_other errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/blobServices') and filter('responsetype', 'ServerOtherError') and ${module.filter-tags.filter_custom})${var.blob_server_other_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/blobServices') and ${module.filter-tags.filter_custom})${var.blob_server_other_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.blob_server_other_error_requests_transformation_function}(over='${var.blob_server_other_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.blob_server_other_error_requests_threshold_critical}, ‘above’, lasting('${var.blob_server_other_error_requests_aperiodic_duration}', ${var.blob_server_other_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.blob_server_other_error_requests_threshold_warning}, ‘above’, lasting('${var.blob_server_other_error_requests_aperiodic_duration}', ${var.blob_server_other_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.blob_server_other_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.blob_server_other_error_requests_disabled_critical, var.blob_server_other_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.blob_server_other_error_requests_notifications_critical, var.blob_server_other_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.blob_server_other_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.blob_server_other_error_requests_disabled_warning, var.blob_server_other_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.blob_server_other_error_requests_notifications_warning, var.blob_server_other_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "file_server_other_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage file server_other errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/fileServices') and filter('responsetype', 'ServerOtherError') and ${module.filter-tags.filter_custom})${var.file_server_other_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/fileServices') and ${module.filter-tags.filter_custom})${var.file_server_other_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.file_server_other_error_requests_transformation_function}(over='${var.file_server_other_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.file_server_other_error_requests_threshold_critical}, ‘above’, lasting('${var.file_server_other_error_requests_aperiodic_duration}', ${var.file_server_other_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.file_server_other_error_requests_threshold_warning}, ‘above’, lasting('${var.file_server_other_error_requests_aperiodic_duration}', ${var.file_server_other_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.file_server_other_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.file_server_other_error_requests_disabled_critical, var.file_server_other_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.file_server_other_error_requests_notifications_critical, var.file_server_other_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.file_server_other_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.file_server_other_error_requests_disabled_warning, var.file_server_other_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.file_server_other_error_requests_notifications_warning, var.file_server_other_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "queue_server_other_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage queue server_other errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/queueServices') and filter('responsetype', 'ServerOtherError') and ${module.filter-tags.filter_custom})${var.queue_server_other_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/queueServices') and ${module.filter-tags.filter_custom})${var.queue_server_other_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.queue_server_other_error_requests_transformation_function}(over='${var.queue_server_other_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.queue_server_other_error_requests_threshold_critical}, ‘above’, lasting('${var.queue_server_other_error_requests_aperiodic_duration}', ${var.queue_server_other_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.queue_server_other_error_requests_threshold_warning}, ‘above’, lasting('${var.queue_server_other_error_requests_aperiodic_duration}', ${var.queue_server_other_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.queue_server_other_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.queue_server_other_error_requests_disabled_critical, var.queue_server_other_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.queue_server_other_error_requests_notifications_critical, var.queue_server_other_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.queue_server_other_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.queue_server_other_error_requests_disabled_warning, var.queue_server_other_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.queue_server_other_error_requests_notifications_warning, var.queue_server_other_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "table_server_other_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage table server_other errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/tableServices') and filter('responsetype', 'ServerOtherError') and ${module.filter-tags.filter_custom})${var.table_server_other_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/tableServices') and ${module.filter-tags.filter_custom})${var.table_server_other_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.table_server_other_error_requests_transformation_function}(over='${var.table_server_other_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.table_server_other_error_requests_threshold_critical}, ‘above’, lasting('${var.table_server_other_error_requests_aperiodic_duration}', ${var.table_server_other_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.table_server_other_error_requests_threshold_warning}, ‘above’, lasting('${var.table_server_other_error_requests_aperiodic_duration}', ${var.table_server_other_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.table_server_other_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.table_server_other_error_requests_disabled_critical, var.table_server_other_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.table_server_other_error_requests_notifications_critical, var.table_server_other_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.table_server_other_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.table_server_other_error_requests_disabled_warning, var.table_server_other_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.table_server_other_error_requests_notifications_warning, var.table_server_other_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "blob_client_other_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage blob client_other errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/blobServices') and filter('responsetype', 'ClientOtherError') and (not filter('apiname', 'GetBlobProperties')) and (not filter('apiname', 'CreateContainer')) and ${module.filter-tags.filter_custom})${var.blob_client_other_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/blobServices') and (not filter('apiname', 'GetBlobProperties')) and (not filter('apiname', 'CreateContainer')) and ${module.filter-tags.filter_custom})${var.blob_client_other_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.blob_client_other_error_requests_transformation_function}(over='${var.blob_client_other_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.blob_client_other_error_requests_threshold_critical}, ‘above’, lasting('${var.blob_client_other_error_requests_aperiodic_duration}', ${var.blob_client_other_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.blob_client_other_error_requests_threshold_warning}, ‘above’, lasting('${var.blob_client_other_error_requests_aperiodic_duration}', ${var.blob_client_other_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.blob_client_other_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.blob_client_other_error_requests_disabled_critical, var.blob_client_other_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.blob_client_other_error_requests_notifications_critical, var.blob_client_other_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.blob_client_other_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.blob_client_other_error_requests_disabled_warning, var.blob_client_other_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.blob_client_other_error_requests_notifications_warning, var.blob_client_other_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "file_client_other_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage file client_other errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/fileServices') and filter('responsetype', 'ClientOtherError') and ${module.filter-tags.filter_custom})${var.file_client_other_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/fileServices') and ${module.filter-tags.filter_custom})${var.file_client_other_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.file_client_other_error_requests_transformation_function}(over='${var.file_client_other_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.file_client_other_error_requests_threshold_critical}, ‘above’, lasting('${var.file_client_other_error_requests_aperiodic_duration}', ${var.file_client_other_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.file_client_other_error_requests_threshold_warning}, ‘above’, lasting('${var.file_client_other_error_requests_aperiodic_duration}', ${var.file_client_other_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.file_client_other_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.file_client_other_error_requests_disabled_critical, var.file_client_other_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.file_client_other_error_requests_notifications_critical, var.file_client_other_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.file_client_other_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.file_client_other_error_requests_disabled_warning, var.file_client_other_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.file_client_other_error_requests_notifications_warning, var.file_client_other_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "queue_client_other_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage queue client_other errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/queueServices') and filter('responsetype', 'ClientOtherError') and ${module.filter-tags.filter_custom})${var.queue_client_other_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/queueServices') and ${module.filter-tags.filter_custom})${var.queue_client_other_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.queue_client_other_error_requests_transformation_function}(over='${var.queue_client_other_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.queue_client_other_error_requests_threshold_critical}, ‘above’, lasting('${var.queue_client_other_error_requests_aperiodic_duration}', ${var.queue_client_other_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.queue_client_other_error_requests_threshold_warning}, ‘above’, lasting('${var.queue_client_other_error_requests_aperiodic_duration}', ${var.queue_client_other_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.queue_client_other_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.queue_client_other_error_requests_disabled_critical, var.queue_client_other_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.queue_client_other_error_requests_notifications_critical, var.queue_client_other_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.queue_client_other_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.queue_client_other_error_requests_disabled_warning, var.queue_client_other_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.queue_client_other_error_requests_notifications_warning, var.queue_client_other_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "table_client_other_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage table client_other errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/tableServices') and filter('responsetype', 'ClientOtherError') and ${module.filter-tags.filter_custom})${var.table_client_other_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/tableServices') and ${module.filter-tags.filter_custom})${var.table_client_other_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.table_client_other_error_requests_transformation_function}(over='${var.table_client_other_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.table_client_other_error_requests_threshold_critical}, ‘above’, lasting('${var.table_client_other_error_requests_aperiodic_duration}', ${var.table_client_other_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.table_client_other_error_requests_threshold_warning}, ‘above’, lasting('${var.table_client_other_error_requests_aperiodic_duration}', ${var.table_client_other_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.table_client_other_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.table_client_other_error_requests_disabled_critical, var.table_client_other_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.table_client_other_error_requests_notifications_critical, var.table_client_other_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.table_client_other_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.table_client_other_error_requests_disabled_warning, var.table_client_other_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.table_client_other_error_requests_notifications_warning, var.table_client_other_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "blob_authorization_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage blob authorization errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/blobServices') and filter('responsetype', 'AuthorizationError') and ${module.filter-tags.filter_custom})${var.blob_authorization_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/blobServices') and ${module.filter-tags.filter_custom})${var.blob_authorization_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.blob_authorization_error_requests_transformation_function}(over='${var.blob_authorization_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.blob_authorization_error_requests_threshold_critical}, ‘above’, lasting('${var.blob_authorization_error_requests_aperiodic_duration}', ${var.blob_authorization_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.blob_authorization_error_requests_threshold_warning}, ‘above’, lasting('${var.blob_authorization_error_requests_aperiodic_duration}', ${var.blob_authorization_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.blob_authorization_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.blob_authorization_error_requests_disabled_critical, var.blob_authorization_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.blob_authorization_error_requests_notifications_critical, var.blob_authorization_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.blob_authorization_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.blob_authorization_error_requests_disabled_warning, var.blob_authorization_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.blob_authorization_error_requests_notifications_warning, var.blob_authorization_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "file_authorization_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage file authorization errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/fileServices') and filter('responsetype', 'AuthorizationError') and ${module.filter-tags.filter_custom})${var.file_authorization_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/fileServices') and ${module.filter-tags.filter_custom})${var.file_authorization_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.file_authorization_error_requests_transformation_function}(over='${var.file_authorization_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.file_authorization_error_requests_threshold_critical}, ‘above’, lasting('${var.file_authorization_error_requests_aperiodic_duration}', ${var.file_authorization_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.file_authorization_error_requests_threshold_warning}, ‘above’, lasting('${var.file_authorization_error_requests_aperiodic_duration}', ${var.file_authorization_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.file_authorization_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.file_authorization_error_requests_disabled_critical, var.file_authorization_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.file_authorization_error_requests_notifications_critical, var.file_authorization_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.file_authorization_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.file_authorization_error_requests_disabled_warning, var.file_authorization_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.file_authorization_error_requests_notifications_warning, var.file_authorization_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "queue_authorization_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage queue authorization errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/queueServices') and filter('responsetype', 'AuthorizationError') and ${module.filter-tags.filter_custom})${var.queue_authorization_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/queueServices') and ${module.filter-tags.filter_custom})${var.queue_authorization_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.queue_authorization_error_requests_transformation_function}(over='${var.queue_authorization_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.queue_authorization_error_requests_threshold_critical}, ‘above’, lasting('${var.queue_authorization_error_requests_aperiodic_duration}', ${var.queue_authorization_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.queue_authorization_error_requests_threshold_warning}, ‘above’, lasting('${var.queue_authorization_error_requests_aperiodic_duration}', ${var.queue_authorization_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.queue_authorization_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.queue_authorization_error_requests_disabled_critical, var.queue_authorization_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.queue_authorization_error_requests_notifications_critical, var.queue_authorization_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.queue_authorization_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.queue_authorization_error_requests_disabled_warning, var.queue_authorization_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.queue_authorization_error_requests_notifications_warning, var.queue_authorization_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}

resource "signalfx_detector" "table_authorization_error_requests" {
	name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Azure storage table authorization errors"

	program_text = <<-EOF
		from signalfx.detectors.aperiodic import aperiodic
		A = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/tableServices') and filter('responsetype', 'AuthorizationError') and ${module.filter-tags.filter_custom})${var.table_authorization_error_requests_aggregation_function}
		B = data('Transactions', filter=filter('resource_type', 'Microsoft.Storage/storageAccounts/tableServices') and ${module.filter-tags.filter_custom})${var.table_authorization_error_requests_aggregation_function}
		signal = (A/B).scale(100).${var.table_authorization_error_requests_transformation_function}(over='${var.table_authorization_error_requests_transformation_window}').publish('signal')
		above_or_below_detector(signal, ${var.table_authorization_error_requests_threshold_critical}, ‘above’, lasting('${var.table_authorization_error_requests_aperiodic_duration}', ${var.table_authorization_error_requests_aperiodic_percentage})).publish('CRIT')
		above_or_below_detector(signal, ${var.table_authorization_error_requests_threshold_warning}, ‘above’, lasting('${var.table_authorization_error_requests_aperiodic_duration}', ${var.table_authorization_error_requests_aperiodic_percentage})).publish('WARN')
	EOF

	rule {
		description           = "is too high > ${var.table_authorization_error_requests_threshold_critical}"
		severity              = "Critical"
		detect_label          = "CRIT"
		disabled              = coalesce(var.table_authorization_error_requests_disabled_critical, var.table_authorization_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.table_authorization_error_requests_notifications_critical, var.table_authorization_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

	rule {
		description           = "is too high > ${var.table_authorization_error_requests_threshold_warning}"
		severity              = "Warning"
		detect_label          = "WARN"
		disabled              = coalesce(var.table_authorization_error_requests_disabled_warning, var.table_authorization_error_requests_disabled, var.detectors_disabled)
		notifications         = coalescelist(var.table_authorization_error_requests_notifications_warning, var.table_authorization_error_requests_notifications, var.notifications)
		parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
	}

}