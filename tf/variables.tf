variable "location" {
  type    = string
  default = "us-east1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "project" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "kafka_node_count" {
  type = number
  default = 3
}

variable "cidr_range" {
  type = string
  default = "10.2.0.0/16"
}

variable "bastion_cidr_range" {
  type = string
  default = "10.3.0.0/16"
}

variable "gce_ssh_pub_key_file" {
  type = string
}

variable "member_account" {
  type = string
}
