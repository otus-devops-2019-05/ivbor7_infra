# Terraform file

data "template_file" "puma_service" {
  template = "${file("${path.module}/files/puma.service")}"
  vars = {
    db_int_ipaddress  = "${var.db_int_ip}"
    port              = "27017"
  }
}

# only for Terraform 0.12 and later
# templatefile("${path.module}/files/puma.service")}", { port = 27017, db_int_ipaddress  = "${var.db_int_ip}" })



resource "google_compute_instance" "app" {
  name = "reddit-app-${count.index+1}"
  count = "${var.count_instance}"
  machine_type = "f1-micro"
  zone = "${var.zone}"
  tags = ["reddit-app"]
  boot_disk {
    initialize_params { image = "${var.app_disk_image}" }
  }
 
  network_interface {
    network = "default"
    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }
  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type  = "ssh"
    user  = "appuser"
    agent = false
    host  = "${google_compute_address.app_ip.address}"
    private_key = "${file(var.private_key)}"
  }

#  provisioner "file" {
#    source      = "../modules/app/files/puma.service"
#    content      = "${data.template_file.puma_service.rendered}"
#    destination = "/tmp/puma.service"
#  }

  provisioner "file" {
    source      = "../modules/app/files/deploy.sh"
    destination = "/tmp/deploy.sh"
  }

  provisioner "remote-exec" {
    inline = ["chmod +x /tmp/deploy.sh","${var.enable_provisioning == "true" ? local.inst-app : local.noapp}"]
  }
}

locals {
  inst-app    = "bash /tmp/deploy.sh"
  noapp = "echo 'The app will not be installed'"
}


resource "google_compute_address" "app_ip" { name = "reddit-app-ip" }


resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  network = "default"
  allow {
    protocol = "tcp", ports = ["9292"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["reddit-app"]
}

