# Terraform file

variable public_key_path {
description = "Path to the public key used to connect to instance"
}

variable private_key {
  description = "Path to the private key used for ssh access"
}

variable zone {
description = "Zone"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default = "reddit-app-base"
}

variable "count_instance" {
  type        = "string"
  description = "Number of instances"
  default     = "1"
}

variable "enable_provisioning" {
  description	= "If set to true, enable provisioning"
}

variable "db_int_ip" {
  type		= "string"
  description	= "Internal IP address of db instance"
}
