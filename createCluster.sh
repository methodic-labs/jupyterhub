#!/usr/bin/env bash

. setEnvVars.sh

echo "Creating Kubernetes cluster"
# Assumes a key named 'cluster_rsa' exists, use ubuntu 20.04 standard ami
kops create cluster \
  --zones "us-gov-west-1a,us-gov-west-1b,us-gov-west-1c" --authorization RBAC \
  --master-size t3.2xlarge --master-volume-size 20 \
  --node-size r5.4xlarge --node-volume-size 20 \
  --topology private \
  --networking weave \
  --bastion="true" \
  --image ami-84556de5 \
  --ssh-public-key ./cluster_rsa.pub --yes

#  --image openlattice/jupyterhub-datascience $PRIVATE_OPTIONS --ssh-public-key ./cluster_rsa.pub --yes

time until kops validate cluster; do sleep 15; done

kubectl get nodes


echo "Kubernetes cluster creation complete"

echo "Installing Helm"
# install and configure helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash


time until helm version; do sleep 15; done

kubectl get nodes

echo "Kubernetes cluster creation complete"

echo "Installing Helm"
# install and configure helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash


time until helm version; do sleep 15; done

helm list

echo "Helm installation complete"
echo "Setting up storage class"
kubectl replace -f storageclass.yaml --force
echo "Storage class set"
echo "Next setup namespace storage"
