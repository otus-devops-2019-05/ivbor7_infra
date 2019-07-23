terraform {
  backend "gcs" {
    bucket = "ivb-trform-stage"
    prefix = "stage"
  }
}
