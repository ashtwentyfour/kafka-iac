variable "zk_node_count" {
  type = number
  default = 3
}

variable "machine_type" {
  type = string
  default = "e2-medium"
}

variable "image" {
  type = string
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "kafka_vm_name" {
    type = string
}

variable "availability_zone" {
    type = string
}

variable "network" {
    type = string
}

variable "subnetwork" {
    type = string
}

variable "kafka_gce_ssh_user" {
    type = string
    default = "kafka"
}

variable "zk_gce_ssh_user" {
    type = string
    default = "zk"
}

variable "gce_ssh_pub_key_file" {
    type = string
}

variable "labels" {
    type = map
}
