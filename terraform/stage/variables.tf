# Terraform file eith variables definitions

variable project {
  description = "Project ID"

  #  default = "infra-244305"
}

variable region {
  description = "Region"

  # default value
  default = "us-central1"
}

variable zone {
  description = "Zone"
}

variable ssh_user {
  description = "First ssh user"
}

variable ssh_user1 {
  description = "Second ssh user"
}

variable ssh_user2 {
  description = "Third ssh user"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key {
  description = "Path to the private key used for ssh access"
}

variable disk_image {
  description = "Disk image"
  default     = "reddit-base"
}

variable count_instance {
  description = "number of instances"
  default     = 1
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable enable_provisioning {
  description	= "If set to true, enable provisioning"
  default	= 1
}
