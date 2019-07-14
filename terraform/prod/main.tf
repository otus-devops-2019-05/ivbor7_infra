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
  source          = "../modules/app"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  app_disk_image  = "${var.app_disk_image}"
  count_instance  = "${var.count_instance}"

  #  app_external_ip = "${var.module.app.app_ext_ip}"
}

module "db" {
  source          = "../modules/db"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  db_disk_image   = "${var.db_disk_image}"
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["178.94.14.149/32"]

  #  source_ranges = ["0.0.0.0/0"]
}
