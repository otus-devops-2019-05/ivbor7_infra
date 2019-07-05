terraform {
  # version of  terraform
  required_version = "0.11.11"
}

provider "google" {
  # provider version
  version = "2.0.0"
 # ID project
  project = "infra-244305"
  region = "us-central1"
}

resource "google_compute_instance" "app" {
  name = "reddit-app"
  machine_type = "f1-micro"
  zone = "us-central1-a"

  metadata {
 # path to ssh public key
  ssh-keys = "appuser:${file("~/.ssh/appuser.pub")}"
}

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
