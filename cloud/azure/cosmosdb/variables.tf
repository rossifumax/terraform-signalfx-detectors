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

# Azure cosmosdb detectors specific

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

# 4xx_requests detectors

variable "4xx_requests_disabled" {
  description = "Disable all alerting rules for 4xx_requests detector"
  type        = bool
  default     = null
}

variable "4xx_requests_disabled_critical" {
  description = "Disable critical alerting rule for 4xx_requests detector"
  type        = bool
  default     = null
}

variable "4xx_requests_disabled_warning" {
  description = "Disable warning alerting rule for 4xx_requests detector"
  type        = bool
  default     = null
}

variable "4xx_requests_notifications" {
  description = "Notification recipients list for every alerting rules of 4xx_requests detector"
  type        = list
  default     = []
}

variable "4xx_requests_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of 4xx_requests detector"
  type        = list
  default     = []
}

variable "4xx_requests_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of 4xx_requests detector"
  type        = list
  default     = []
}

variable "4xx_requests_aggregation_function" {
  description = "Aggregation function and group by for 4xx_requests detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ".sum(by=['azure_resource_group_name', 'azure_resource_name', 'collectionname'])"
}

variable "4xx_requests_transformation_function" {
  description = "Transformation function for 4xx_requests detector (mean, min, max)"
  type        = string
  default     = "min"
}

variable "4xx_requests_transformation_window" {
  description = "Transformation window for 4xx_requests detector (i.e. 5m, 20m, 1h, 1d)"
  type        = string
  default     = "5m"
}

variable "4xx_requests_threshold_critical" {
  description = "Critical threshold for 4xx_requests detector"
  type        = number
  default     = 80
}

variable "4xx_requests_threshold_warning" {
  description = "Warning threshold for 4xx_requests detector"
  type        = number
  default     = 50
}

variable "4xx_requests_aperiodic_duration" {
  description = "Duration for the 4xx_requests block"
  type        = string
  default     = "10m"
}

variable "4xx_requests_aperiodic_percentage" {
  description = "Percentage for the 4xx_requests block"
  type        = number
  default     = 0.9
}

# 5xx_requests detectors

variable "5xx_requests_disabled" {
  description = "Disable all alerting rules for 5xx_requests detector"
  type        = bool
  default     = null
}

variable "5xx_requests_disabled_critical" {
  description = "Disable critical alerting rule for 5xx_requests detector"
  type        = bool
  default     = null
}

variable "5xx_requests_disabled_warning" {
  description = "Disable warning alerting rule for 5xx_requests detector"
  type        = bool
  default     = null
}

variable "5xx_requests_notifications" {
  description = "Notification recipients list for every alerting rules of 5xx_requests detector"
  type        = list
  default     = []
}

variable "5xx_requests_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of 5xx_requests detector"
  type        = list
  default     = []
}

variable "5xx_requests_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of 5xx_requests detector"
  type        = list
  default     = []
}

variable "5xx_requests_aggregation_function" {
  description = "Aggregation function and group by for 5xx_requests detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ".sum(by=['azure_resource_group_name', 'azure_resource_name', 'collectionname'])"
}

variable "5xx_requests_transformation_function" {
  description = "Transformation function for 5xx_requests detector (mean, min, max)"
  type        = string
  default     = "min"
}

variable "5xx_requests_transformation_window" {
  description = "Transformation window for 5xx_requests detector (i.e. 5m, 20m, 1h, 1d)"
  type        = string
  default     = "5m"
}

variable "5xx_requests_threshold_critical" {
  description = "Critical threshold for 5xx_requests detector"
  type        = number
  default     = 80
}

variable "5xx_requests_threshold_warning" {
  description = "Warning threshold for 5xx_requests detector"
  type        = number
  default     = 50
}

variable "5xx_requests_aperiodic_duration" {
  description = "Duration for the 5xx_requests block"
  type        = string
  default     = "10m"
}

variable "5xx_requests_aperiodic_percentage" {
  description = "Percentage for the 5xx_requests block"
  type        = number
  default     = 0.9
}

# Scaling detectors

variable "scaling_disabled" {
  description = "Disable all alerting rules for scaling detector"
  type        = bool
  default     = null
}

variable "scaling_disabled_critical" {
  description = "Disable critical alerting rule for scaling detector"
  type        = bool
  default     = null
}

variable "scaling_disabled_warning" {
  description = "Disable warning alerting rule for scaling detector"
  type        = bool
  default     = null
}

variable "scaling_notifications" {
  description = "Notification recipients list for every alerting rules of scaling detector"
  type        = list
  default     = []
}

variable "scaling_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of scaling detector"
  type        = list
  default     = []
}

variable "scaling_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of scaling detector"
  type        = list
  default     = []
}

variable "scaling_aggregation_function" {
  description = "Aggregation function and group by for scaling detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ".sum(by=['azure_resource_group_name', 'azure_resource_name', 'databasename', 'collectionname'])"
}

variable "scaling_transformation_function" {
  description = "Transformation function for scaling detector (mean, min, max)"
  type        = string
  default     = "min"
}

variable "scaling_transformation_window" {
  description = "Transformation window for scaling detector (i.e. 5m, 20m, 1h, 1d)"
  type        = string
  default     = "5m"
}

variable "scaling_threshold_critical" {
  description = "Critical threshold for scaling detector"
  type        = number
  default     = 10
}

variable "scaling_threshold_warning" {
  description = "Warning threshold for scaling detector"
  type        = number
  default     = 5
}

variable "scaling_aperiodic_duration" {
  description = "Duration for the scaling block"
  type        = string
  default     = "10m"
}

variable "scaling_aperiodic_percentage" {
  description = "Percentage for the scaling block"
  type        = number
  default     = 0.9
}