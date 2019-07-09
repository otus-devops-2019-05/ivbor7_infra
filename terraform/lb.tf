#Create group of servers
resource "google_compute_instance_group" "reddit-cluster" {
  name = "reddit-cluster"
  description = "Reddit cluster"
  instances = [
 "${google_compute_instance.app.*.self_link}"
  ]

  named_port {
    name = "puma-http"
    port = "9292"
  }

  zone = "${var.zone}"
}

# Create backend for lb with health check of the instances
resource "google_compute_backend_service" "reddit-backend" {
  name = "reddit-backend"
  port_name = "puma-http"
  protocol = "HTTP"

  backend {
    group = "${google_compute_instance_group.reddit-cluster.self_link}"
  }

  health_checks = [ "${google_compute_http_health_check.reddit-health.self_link}" ]
}

# add health check
resource "google_compute_http_health_check" "reddit-health" {
  name = "reddit-health"
  port = "9292"
  timeout_sec         = 3
  check_interval_sec  = 5
  unhealthy_threshold = 3
}

# Create urlmap to direct traffic to different instances based on the incoming URL:
resource "google_compute_url_map" "reddit-lb" {
  name = "reddit-lb"
  description = "URL map filters incoming traffic"
  default_service = "${google_compute_backend_service.reddit-backend.self_link}"
}

#Create target http proxy
resource "google_compute_target_http_proxy" "reddit-target-proxy" {
  name = "reddit-app-target-proxy"
  url_map = "${google_compute_url_map.reddit-lb.self_link}"
}

#Create forward rule to forward http to proxy
resource "google_compute_global_forwarding_rule" "reddit-forward" {
  name = "reddit-forward"
  target = "${google_compute_target_http_proxy.reddit-target-proxy.self_link}"
  port_range = "80"
}
