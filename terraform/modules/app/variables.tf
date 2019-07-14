# Terraform file

variable public_key_path {
description = "Path to the public key used to connect to instance"
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