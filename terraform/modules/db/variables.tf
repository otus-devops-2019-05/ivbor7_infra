# Terraform file
variable public_key_path {
  description = "Path to the public key used to connect to instance"
}

variable private_key {
  description = "Path to the private key used to connect to instance"
}

variable region {
  description = "Region"
  default = "us-central1"
}

variable zone {
description = "Zone"
}

variable db_disk_image {
description = "Disk image for reddit db"
default = "reddit-db-base"
}

variable "app_ext_ip" {
  description = "external ip of app-server"
}
