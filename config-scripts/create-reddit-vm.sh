#!/bin/bash


gcloud compute --project=infra-244305 instances create reddit-app \
  --zone=us-central1-a \
  --machine-type=f1-micro \
  --network=default \
  --tags=http-server,https-server,puma-server \
  --image-family=reddit-full \
  --image-project=infra-244305 \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=reddit-app


gcloud compute --project=infra-244305 firewall-rules create default-puma-server\
  --description="rules for puma-server for test app"\
  --direction=INGRESS\
  --priority=1000\
  --network=default\
  --action=ALLOW\
  --rules=tcp:9292\
  --source-ranges=0.0.0.0/0\
  --target-tags=puma-server
