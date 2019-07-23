# Reckon the internal IP address of the DB instance

output "db_int_ip" {
  value = "${google_compute_instance.db.network_interface.0.network_ip}"
}

output "db_ext_ip" {
  value = "${google_compute_instance.db.network_interface.0.access_config.0.nat_ip}"
}
