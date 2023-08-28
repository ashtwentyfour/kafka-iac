resource "google_compute_instance" "kafka-vm" {

  name         = var.kafka_vm_name
  machine_type = var.machine_type
  zone         = var.availability_zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = var.network
    subnetwork = var.subnetwork
  }

  metadata = {
    ssh-keys = "${var.kafka_gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  tags = ["kafka"]

  labels = var.labels

}

resource "google_compute_instance" "zookeeper-vm" {

  count = var.kafka_vm_name == "kafka-vm-0" ? var.zk_node_count : 0
  name         = "zookeeper-vm-${count.index}"
  machine_type = var.machine_type
  zone         = var.availability_zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = var.network
    subnetwork = var.subnetwork
  }

  metadata = {
    ssh-keys = "${var.zk_gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  tags = ["zookeeper"]

  labels = var.labels

}
