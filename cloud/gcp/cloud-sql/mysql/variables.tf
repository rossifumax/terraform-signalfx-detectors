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

# GCP CloudSQL mySQL detectors specific

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

# Replication_lag detectors

variable "replication_lag_disabled" {
  description = "Disable all alerting rules for replication_lag detector"
  type        = bool
  default     = null
}

variable "replication_lag_disabled_critical" {
  description = "Disable critical alerting rule for replication_lag detector"
  type        = bool
  default     = null
}

variable "replication_lag_disabled_warning" {
  description = "Disable warning alerting rule for replication_lag detector"
  type        = bool
  default     = null
}

variable "replication_lag_notifications" {
  description = "Notification recipients list for every alerting rules of replication_lag detector"
  type        = list
  default     = []
}

variable "replication_lag_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of replication_lag detector"
  type        = list
  default     = []
}

variable "replication_lag_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of replication_lag detector"
  type        = list
  default     = []
}

variable "replication_lag_aggregation_function" {
  description = "Aggregation function and group by for replication_lag detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ".mean(by=['database_id'])"
}

variable "replication_lag_transformation_function" {
  description = "Transformation function for replication_lag detector (mean, min, max)"
  type        = string
  default     = "min"
}

variable "replication_lag_transformation_window" {
  description = "Transformation window for replication_lag detector (i.e. 5m, 20m, 1h, 1d)"
  type        = string
  default     = "10m"
}

variable "replication_lag_threshold_critical" {
  description = "Critical threshold for replication_lag detector"
  type        = number
  default     = 180
}

variable "replication_lag_threshold_warning" {
  description = "Warning threshold for replication_lag detector"
  type        = number
  default     = 90
}
