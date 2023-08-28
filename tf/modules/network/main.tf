resource "google_compute_network" "kafka-network" {
  name                    = "kafka-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "kafka-subnetwork" {
  name          = "kafka-subnetwork"
  ip_cidr_range = var.cidr_range
  region        = var.location
  network       = google_compute_network.kafka-network.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "bastion-subnetwork" {
  name          = "bastion-subnetwork"
  ip_cidr_range = var.bastion_cidr_range
  region        = var.location
  network       = google_compute_network.kafka-network.id
  private_ip_google_access = true
}

resource "google_compute_firewall" "kafka-firewall" {
  name    = "allow-kafka-zookeeper"
  network = google_compute_network.kafka-network.id

  allow {
    protocol = "tcp"
    ports    = ["22", "9092", "9093", "2181", "2887-3889"]
  }

  source_ranges = [var.cidr_range, var.bastion_cidr_range]
  target_tags   = ["kafka", "zookeeper"]
}

module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 1.2"
  name = "kafka-bastion-cloud-nat"
  project_id = var.project
  region     = var.location
  router     = "kafka-bastion-cloud-router"
  network       = google_compute_network.kafka-network.id
  create_router = true
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetworks = [
    {
      name = google_compute_subnetwork.bastion-subnetwork.id
      source_ip_ranges_to_nat = [var.bastion_cidr_range]
      secondary_ip_range_names = []
    }
  ]
}
