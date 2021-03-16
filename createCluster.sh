#!/usr/bin/env bash

. setEnvVars.sh

if [[ $1 == *private || $1 == -p ]]
then
  PRIVATE_OPTIONS="--topology private --networking weave"
else
  PRIVATE_OPTIONS=""
fi

echo "Creating Kubernetes cluster"
# Assumes a key named 'cluster_rsa' exists
kops create cluster "$NAME" --zones "us-gov-west-1a,us-gov-west-1b,us-gov-west-1c" --authorization RBAC \
  --master-size t3.large --master-volume-size 20 \
  --node-size t3.xlarge --node-volume-size 20 \
  --image openlattice/jupyterhub-datascience "$PRIVATE_OPTIONS" --ssh-public-key ./cluster_rsa.pub --yes

time until kops validate cluster; do sleep 15; done

kubectl get nodes


echo "Kubernetes cluster creation complete"

if [ ! -z "$PRIVATE_OPTIONS" ]
then
  # not sure about --image, may have to manually edit the config file to add it in :(
  kops create instancegroup bastions --role Bastion --subnet utility-us-gov-west-1a --name "$NAME" \
    --image openlattice/jupyterhub-datascience \
    --edit false

  kops update cluster "$NAME" --yes

  time until kops validate cluster; do sleep 15; done

  kubectl get nodes
fi

echo "Installing Helm"
# install and configure helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash


time until helm version; do sleep 15; done

helm list

echo "Helm installation complete"
echo "Next setup namespace storage"
