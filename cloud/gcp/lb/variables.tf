# Global

variable "environment" {
  description = "Infrastructure environment"
  type        = string
}

# SignalFx module specific

variable "notifications" {
  description = "Notification recipients list for every detectors"
  type        = list
}

variable "prefixes" {
  description = "Prefixes list to prepend between brackets on every monitors names before environment"
  type        = list
  default     = []
}

variable "filter_custom_includes" {
  description = "List of tags to include when custom filtering is used"
  type        = list
  default     = []
}

variable "filter_custom_excludes" {
  description = "List of tags to exclude when custom filtering is used"
  type        = list
  default     = []
}

variable "detectors_disabled" {
  description = "Disable all detectors in this module"
  type        = bool
  default     = false
}

# GCP LB detectors specific

variable "heartbeat_disabled" {
  description = "Disable all alerting rules for heartbeat detector"
  type        = bool
  default     = null
}

variable "heartbeat_notifications" {
  description = "Notification recipients list for every alerting rules of heartbeat detector"
  type        = list
  default     = []
}

variable "heartbeat_timeframe" {
  description = "Timeframe for system not reporting detector (i.e. \"10m\")"
  type        = string
  default     = "20m"
}

# Error_rate_4xx detectors

variable "error_rate_4xx_disabled" {
  description = "Disable all alerting rules for error_rate_4xx detector"
  type        = bool
  default     = null
}

variable "error_rate_4xx_disabled_critical" {
  description = "Disable critical alerting rule for error_rate_4xx detector"
  type        = bool
  default     = null
}

variable "error_rate_4xx_disabled_warning" {
  description = "Disable warning alerting rule for error_rate_4xx detector"
  type        = bool
  default     = null
}

variable "error_rate_4xx_notifications" {
  description = "Notification recipients list for every alerting rules of error_rate_4xx detector"
  type        = list
  default     = []
}

variable "error_rate_4xx_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of error_rate_4xx detector"
  type        = list
  default     = []
}

variable "error_rate_4xx_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of error_rate_4xx detector"
  type        = list
  default     = []
}

variable "error_rate_4xx_aggregation_function" {
  description = "Aggregation function and group by for error_rate_4xx detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ".mean()"
}

variable "error_rate_4xx_transformation_function" {
  description = "Transformation function for error_rate_4xx detector (mean, min, max)"
  type        = string
  default     = "min"
}

variable "error_rate_4xx_transformation_window" {
  description = "Transformation window for error_rate_4xx detector (i.e. 5m, 20m, 1h, 1d)"
  type        = string
  default     = "5m"
}

variable "error_rate_4xx_threshold_critical" {
  description = "Critical threshold for error_rate_4xx detector"
  type        = number
  default     = 60
}

variable "error_rate_4xx_threshold_warning" {
  description = "Warning threshold for error_rate_4xx detector"
  type        = number
  default     = 50
}

variable “error_rate_4xx_threshold_number_requests" {
  description = "Number threshold for error_rate_4xx detector"
  type        = number
  default     = 5
}

# Error_rate_5xx detectors

variable "error_rate_5xx_disabled" {
  description = "Disable all alerting rules for error_rate_5xx detector"
  type        = bool
  default     = null
}

variable "error_rate_5xx_disabled_critical" {
  description = "Disable critical alerting rule for error_rate_5xx detector"
  type        = bool
  default     = null
}

variable "error_rate_5xx_disabled_warning" {
  description = "Disable warning alerting rule for error_rate_5xx detector"
  type        = bool
  default     = null
}

variable "error_rate_5xx_notifications" {
  description = "Notification recipients list for every alerting rules of error_rate_5xx detector"
  type        = list
  default     = []
}

variable "error_rate_5xx_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of error_rate_5xx detector"
  type        = list
  default     = []
}

variable "error_rate_5xx_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of error_rate_5xx detector"
  type        = list
  default     = []
}

variable "error_rate_5xx_aggregation_function" {
  description = "Aggregation function and group by for error_rate_5xx detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ".mean()"
}

variable "error_rate_5xx_transformation_function" {
  description = "Transformation function for error_rate_5xx detector (mean, min, max)"
  type        = string
  default     = "min"
}

variable "error_rate_5xx_transformation_window" {
  description = "Transformation window for error_rate_5xx detector (i.e. 5m, 20m, 1h, 1d)"
  type        = string
  default     = "5m"
}

variable "error_rate_5xx_threshold_critical" {
  description = "Critical threshold for error_rate_5xx detector"
  type        = number
  default     = 40
}

variable "error_rate_5xx_threshold_warning" {
  description = "Warning threshold for error_rate_5xx detector"
  type        = number
  default     = 30
}

variable “error_rate_5xx_threshold_number_requests" {
  description = "Number threshold for error_rate_5xx detector"
  type        = number
  default     = 5
}

# Backend_latency detectors

variable "backend_latency_disabled" {
  description = "Disable all alerting rules for backend_latency detector"
  type        = bool
  default     = null
}

variable "backend_latency_disabled_critical" {
  description = "Disable critical alerting rule for backend_latency detector"
  type        = bool
  default     = null
}

variable "backend_latency_disabled_warning" {
  description = "Disable warning alerting rule for backend_latency detector"
  type        = bool
  default     = null
}

variable "backend_latency_notifications" {
  description = "Notification recipients list for every alerting rules of backend_latency detector"
  type        = list
  default     = []
}

variable "backend_latency_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of backend_latency detector"
  type        = list
  default     = []
}

variable "backend_latency_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of backend_latency detector"
  type        = list
  default     = []
}

variable "backend_latency_aggregation_function" {
  description = "Aggregation function and group by for backend_latency detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ".min(by=['backend_target_name'])"
}

variable "backend_latency_transformation_function" {
  description = "Transformation function for backend_latency detector (mean, min, max)"
  type        = string
  default     = "min"
}

variable "backend_latency_transformation_window" {
  description = "Transformation window for backend_latency detector (i.e. 5m, 20m, 1h, 1d)"
  type        = string
  default     = "10m"
}

variable "backend_latency_threshold_critical" {
  description = "Critical threshold for backend_latency detector"
  type        = number
  default     = 1500
}

variable "backend_latency_threshold_warning" {
  description = "Warning threshold for backend_latency detector"
  type        = number
  default     = 1000
}

variable "backend_latency_aperiodic_duration" {
  description = "Duration for the backend_latency block"
  type        = string
  default     = "10m"
}

variable "backend_latency_aperiodic_percentage" {
  description = "Percentage for the backend_latency block"
  type        = number
  default     = 0.9
}

# Backend_latency_bucket detectors

variable "backend_latency_bucket_disabled" {
  description = "Disable all alerting rules for backend_latency_bucket detector"
  type        = bool
  default     = null
}

variable "backend_latency_bucket_disabled_critical" {
  description = "Disable critical alerting rule for backend_latency_bucket detector"
  type        = bool
  default     = null
}

variable "backend_latency_bucket_disabled_warning" {
  description = "Disable warning alerting rule for backend_latency_bucket detector"
  type        = bool
  default     = null
}

variable "backend_latency_bucket_notifications" {
  description = "Notification recipients list for every alerting rules of backend_latency_bucket detector"
  type        = list
  default     = []
}

variable "backend_latency_bucket_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of backend_latency_bucket detector"
  type        = list
  default     = []
}

variable "backend_latency_bucket_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of backend_latency_bucket detector"
  type        = list
  default     = []
}

variable "backend_latency_bucket_aggregation_function" {
  description = "Aggregation function and group by for backend_latency_bucket detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ".min(by=['backend_target_name'])"
}

variable "backend_latency_bucket_transformation_function" {
  description = "Transformation function for backend_latency_bucket detector (mean, min, max)"
  type        = string
  default     = "min"
}

variable "backend_latency_bucket_transformation_window" {
  description = "Transformation window for backend_latency_bucket detector (i.e. 5m, 20m, 1h, 1d)"
  type        = string
  default     = "10m"
}

variable "backend_latency_bucket_threshold_critical" {
  description = "Critical threshold for backend_latency_bucket detector"
  type        = number
  default     = 8000
}

variable "backend_latency_bucket_threshold_warning" {
  description = "Warning threshold for backend_latency_bucket detector"
  type        = number
  default     = 4000
}

variable "backend_latency_bucket_aperiodic_duration" {
  description = "Duration for the backend_latency_bucket block"
  type        = string
  default     = "10m"
}

variable "backend_latency_bucket_aperiodic_percentage" {
  description = "Percentage for the backend_latency_bucket block"
  type        = number
  default     = 0.9
}

# Request_count detectors

variable "request_count_disabled" {
  description = "Disable all alerting rules for request_count detector"
  type        = bool
  default     = null
}

variable "request_count_disabled_critical" {
  description = "Disable critical alerting rule for request_count detector"
  type        = bool
  default     = null
}

variable "request_count_disabled_warning" {
  description = "Disable warning alerting rule for request_count detector"
  type        = bool
  default     = null
}

variable "request_count_notifications" {
  description = "Notification recipients list for every alerting rules of request_count detector"
  type        = list
  default     = []
}

variable "request_count_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of request_count detector"
  type        = list
  default     = []
}

variable "request_count_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of request_count detector"
  type        = list
  default     = []
}

variable "request_count_aggregation_function" {
  description = "Aggregation function and group by for request_count detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ".sum(by=['forwarding_rule_name'])"
}

variable "request_count_transformation_function" {
  description = "Transformation function for request_count detector (mean, min, max)"
  type        = string
  default     = "sum"
}

variable "request_count_transformation_window" {
  description = "Transformation window for request_count detector (i.e. 5m, 20m, 1h, 1d)"
  type        = string
  default     = "5m"
}

variable "request_count_threshold_critical" {
  description = "Critical threshold for request_count detector"
  type        = number
  default     = 500
}

variable "request_count_threshold_warning" {
  description = "Warning threshold for request_count detector"
  type        = number
  default     = 250
}

variable "request_count_aperiodic_duration" {
  description = "Duration for the request_count block"
  type        = string
  default     = "10m"
}

variable "request_count_aperiodic_percentage" {
  description = "Percentage for the request_count block"
  type        = number
  default     = 0.9
}
