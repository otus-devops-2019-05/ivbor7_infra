terraform {
  backend "gcs" {
    bucket = "ivb-trform-prod"
    prefix = "prod"
  }
}
