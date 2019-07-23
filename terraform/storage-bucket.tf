#use storage-bucket module
provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region = "${var.region}"
}

module "storage-bucket" {
  source = "SweetOps/storage-bucket/google"
  version = "0.1.1"
  # the bucket names for each of envs prod and stage
  name = ["ivb-trform-stage", "ivb-trform-prod"]
}

output storage-bucket_url {
  value = "${module.storage-bucket.url}"
}
