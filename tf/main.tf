terraform {
  required_version = ">= 1.0" 
}

locals {
    labels = {
        environment = var.environment
    }
}

module "kafka_network" {
    source = "./modules/network"
    location = var.location
    cidr_range = var.cidr_range
    bastion_cidr_range = var.bastion_cidr_range
    project = var.project
}

module "iap_bastion" {
  name = "kafka-bastion"
  source = "terraform-google-modules/bastion-host/google"
  version = "5.3.0"
  project = var.project
  zone    = var.availability_zone
  network = module.kafka_network.kafka_network
  subnet  = module.kafka_network.bastion_subnetwork
  members = [var.member_account]
  labels = local.labels
}

module "kafka_cluster" {
   source = "./modules/kafka"
   count = var.kafka_node_count
   kafka_vm_name = "kafka-vm-${count.index}"
   availability_zone = var.availability_zone
   network = module.kafka_network.kafka_network
   subnetwork = module.kafka_network.kafka_subnetwork
   gce_ssh_pub_key_file = var.gce_ssh_pub_key_file
   labels = local.labels
}

output "bastion_hostname" {
    value = module.iap_bastion.hostname
}

output "kafka_ips" {
  value = templatefile("templates/inventory.tftpl", {
    kafka_ips = tolist(module.kafka_cluster[*].kafka_ip[*])
    zk_ips = tolist(module.kafka_cluster[*].zookeeper_ip[*])
  })
}
