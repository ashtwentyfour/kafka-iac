output "kafka_ip" {
  value = google_compute_instance.kafka-vm[*].network_interface[0].network_ip
}

output "zookeeper_ip" {
  value = google_compute_instance.zookeeper-vm[*].network_interface[0].network_ip
}
