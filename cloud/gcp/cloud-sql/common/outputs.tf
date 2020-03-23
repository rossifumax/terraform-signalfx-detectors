output "cpu_utilization_id" {
  description = "id for detector cpu_utilization"
  value       = signalfx_detector.cpu_utilization.*.id
}

output "disk_utilization_id" {
  description = "id for detector disk_utilization"
  value       = signalfx_detector.disk_utilization.*.id
}

output "memory_utilization_id" {
  description = "id for detector memory_utilization"
  value       = signalfx_detector.memory_utilization.*.id
}

output "failover_unavailable_id" {
  description = "id for detector failover_unavailable"
  value       = signalfx_detector.failover_unavailable.*.id
}
