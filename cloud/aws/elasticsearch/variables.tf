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

# AWS ElasticSearch detectors specific

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

# Cluster_status detectors

variable "cluster_status_disabled" {
  description = "Disable all alerting rules for cluster status detector"
  type        = bool
  default     = null
}

variable "cluster_status_disabled_critical" {
  description = "Disable critical alerting rule for cluster status detector"
  type        = bool
  default     = null
}

variable "cluster_status_disabled_warning" {
  description = "Disable warning alerting rule for cluster status detector"
  type        = bool
  default     = null
}

variable "cluster_status_notifications" {
  description = "Notification recipients list for every alerting rules of cluster status detector"
  type        = list
  default     = []
}

variable "cluster_status_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of cluster status detector"
  type        = list
  default     = []
}

variable "cluster_status_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of cluster status detector"
  type        = list
  default     = []
}

variable "cluster_status_aggregation_function" {
  description = "Aggregation function and group by for cluster status detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ".mean(by=['aws_region'])"
}

variable "cluster_status_transformation_function" {
  description = "Transformation function for cluster status detector (mean, min, max)"
  type        = string
  default     = "max"
}

variable "cluster_status_transformation_window" {
  description = "Transformation window for cluster status detector (i.e. 5m, 20m, 1h, 1d)"
  type        = string
  default     = "30m"
}

variable "cluster_status_threshold_critical" {
  description = "Critical threshold for cluster status detector"
  type        = number
  default     = 2
}

variable "cluster_status_threshold_warning" {
  description = "Warning threshold for cluster status detector"
  type        = number
  default     = 1
}

# CPU_90_15min detectors

variable "cpu_90_15min_disabled" {
  description = "Disable all alerting rules for cpu_90_15min detector"
  type        = bool
  default     = null
}

variable "cpu_90_15min_disabled_critical" {
  description = "Disable critical alerting rule for cpu_90_15min detector"
  type        = bool
  default     = null
}

variable "cpu_90_15min_disabled_warning" {
  description = "Disable warning alerting rule for httpcode 5xx erros detector"
  type        = bool
  default     = null
}

variable "cpu_90_15min_notifications" {
  description = "Notification recipients list for every alerting rules of cpu_90_15min detector"
  type        = list
  default     = []
}

variable "cpu_90_15min_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of cpu_90_15min detector"
  type        = list
  default     = []
}

variable "cpu_90_15min_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of cpu_90_15min detector"
  type        = list
  default     = []
}

variable "cpu_90_15min_aggregation_function" {
  description = "Aggregation function and group by for cpu_90_15min detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ".mean(by=['aws_region'])"
}

variable "cpu_90_15min_transformation_function" {
  description = "Transformation function for cpu_90_15min detector (mean, min, max)"
  type        = string
  default     = "min"
}

variable "cpu_90_15min_transformation_window" {
  description = "Transformation window for cpu_90_15min detector (i.e. 5m, 20m, 1h, 1d)"
  type        = string
  default     = "15m"
}

variable "cpu_90_15min_threshold_critical" {
  description = "Critical threshold for cpu_90_15min detector"
  type        = number
  default     = 90
}

variable "cpu_90_15min_threshold_warning" {
  description = "Warning threshold for cpu_90_15min detector"
  type        = number
  default     = 80
}
