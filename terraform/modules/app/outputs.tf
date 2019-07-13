# recon the external IP of the app instance

output "app_ext_ip" {
  value = "${google_compute_instance.app.*.network_interface.0.access_config.0.nat_ip}"
#  value = "${google_compute_address.app_ip.address}"
}
