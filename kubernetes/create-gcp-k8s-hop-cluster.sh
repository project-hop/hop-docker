#!/bin/bash
# create project
gcloud projects create k8s-project-hop
# OR if project already exist, set project id
gcloud config set project k8s-project-hop
# set compute zone
# list of available zones
# https://cloud.google.com/compute/docs/regions-zones/#available
gcloud config set compute/zone us-west1-a
# create kubernetes engine cluster
# running command again after enabling API
gcloud container clusters create project-hop-cluster \
  --machine-type=n1-standard-2 \
  --num-nodes=1
# get authentication credentials to interact with cluster
gcloud container clusters get-credentials project-hop-cluster

gcloud container clusters list
kubectl get nodes

## PROJECT HOP SETUP -- START ##
kubectl apply -f hop-job.yaml
kubectl apply -f hop-deployment.yaml