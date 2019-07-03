terraform {
# version of  terraform
required_version = "0.11.11"
}
provider "google" {
# provider virsion
version = "2.0.0"
# ID project
project = "infra-244305"
region = "us-central1"
}

resource "google_compute_instance" "app" {
name
= "reddit-app"
machine_type = "g1-small"
zone
= "europe-west1-b"
# boot disk determination
boot_disk {
initialize_params {
image = "reddit-base"
}
}
# define the network interface
network_interface {
# what network connect to
network = "default"
# use  ephemeral IP to access the Internet
access_config {}
}
}
