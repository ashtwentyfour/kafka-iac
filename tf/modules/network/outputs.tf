output "kafka_network" {
  value = google_compute_network.kafka-network.id
}

output "kafka_subnetwork" {
  value = google_compute_subnetwork.kafka-subnetwork.id
}

output "bastion_subnetwork" {
  value = google_compute_subnetwork.bastion-subnetwork.id
}

output "bastion_cloud_nat" {
  value       = module.cloud-nat.name
}
