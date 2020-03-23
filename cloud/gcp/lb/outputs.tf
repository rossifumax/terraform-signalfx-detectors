output "error_rate_4xx_id" {
  description = "id for detector error_rate_4xx"
  value       = signalfx_detector.error_rate_4xx.*.id
}

output "error_rate_5xx_id" {
  description = "id for detector error_rate_5xx"
  value       = signalfx_detector.error_rate_5xx.*.id
}

output "backend_latency_id" {
  description = "id for detector backend_latency"
  value       = signalfx_detector.backend_latency.*.id
}

output "backend_latency_bucket_id" {
  description = "id for detector backend_latency_bucket"
  value       = signalfx_detector.backend_latency_bucket.*.id
}

output "request_count_id" {
  description = "id for detector request_count"
  value       = signalfx_detector.request_count.*.id
}
