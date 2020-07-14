#!/usr/bin/env bash

. setEnvVars.sh

if [[ $1 == *private || $1 == -p ]]
then
  PRIVATE_OPTIONS="--topology private --networking weave"
else
  PRIVATE_OPTIONS=""
fi

# Assumes a key named 'cluster_rsa' exists
kops create cluster "$CLUSTER_NAME" --zones "us-gov-west-1a,us-gov-west-1b,us-gov-west-1c" --authorization RBAC --master-size t2.large --master-volume-size 20 --node-size t2.xlarge --image openlattice/jupyterhub-datascience $PRIVATE_OPTIONS--node-volume-size 20 --ssh-public-key ./cluster_rsa.pub --yes

time until kops validate cluster; do sleep 15; done

kubectl get nodes

if [ ! -z "$PRIVATE_OPTIONS" ]
then
  # not sure about --image, may have to manually edit the config file to add it in :(
  kops create instancegroup bastions --role Bastion --subnet utility-us-gov-west-1a --name "$CLUSTER_NAME" --image openlattice/jupyterhub-datascience --edit false

  kops update cluster "$CLUSTER_NAME" --yes

  time until kops validate cluster; do sleep 15; done

  kubectl get nodes
fi

# install and configure helm
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

kubectl --namespace kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --wait
kubectl patch deployment tiller-deploy --namespace=kube-system --type=json --patch='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["/tiller", "--listen=localhost:44134"]}]'
helm version

time until helm version; do sleep 15; done
