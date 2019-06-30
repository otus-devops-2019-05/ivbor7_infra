#!/bin/bash


gcloud compute --project=infra-244305 instances create reddit-app \
  --zone=us-central1-a \
  --machine-type=f1-micro \
  --subnet=default \
  --tags=http-server,https-server \
  --image=reddit-base-1561890570 \
  --image-project=infra-244305 \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=reddit-app

gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure\
  --metadata-from-file startup-script=$HOME/Scripts/startup_script.sh

gcloud compute --project=infra-244305 firewall-rules create default-puma-server\
  --description="rules for puma-server for test app"\
  --direction=INGRESS\
  --priority=1000\
  --network=default\
  --action=ALLOW\
  --rules=tcp:9292\
  --source-ranges=0.0.0.0/0\
  --target-tags=puma-server
