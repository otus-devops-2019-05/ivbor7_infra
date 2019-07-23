# Terraform file

resource "google_compute_instance" "db" {
  name = "reddit-db-base"
  machine_type = "f1-micro"
  zone = "${var.zone}"
  tags = ["reddit-db"]
  boot_disk {
    initialize_params {
    image = "${var.db_disk_image}"
  }
}
  network_interface {
    network = "default"
    access_config = {}
  }
  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
  
  connection {
    type  = "ssh"
    user  = "appuser"
    agent = false
    host  = "${google_compute_instance.db.network_interface.0.access_config.0.nat_ip}"
    private_key = "${file(var.private_key)}"
  }


  provisioner "remote-exec" {
    inline = ["sudo sed -i \"s/127.0.0.1/${google_compute_instance.db.network_interface.0.network_ip}/\" /etc/mongod.conf && sudo systemctl restart mongod.service"]
  }


}


# Firewall rule
resource "google_compute_firewall" "firewall_mongo" {
  name = "allow-mongo-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["27017"]
  }
  target_tags = ["reddit-db"]
  source_tags = ["reddit-app"]
}
