# Terraform file
terraform {
  # version of  terraform
  required_version = "~>0.11.7"
}

provider "google" {
  # provider version
  version = "2.0.0"

  # ID project
  project = "${var.project}"
  region  = "${var.region}"
}

module "app" {
  source = "modules/app"
  public_key_path = "${var.public_key_path}"
  zone = "${var.zone}"
  app_disk_image = "${var.app_disk_image}"
#  app_ext_ip = "${module.app.app_ext_ip}"
} 

module "db" {
  source = "modules/db"
  public_key_path = "${var.public_key_path}"
  zone = "${var.zone}"
  db_disk_image = "${var.db_disk_image}"
}

module "vpc" {
  source = "modules/vpc"
  source_ranges = ["80.250.215.124/32"]
}
