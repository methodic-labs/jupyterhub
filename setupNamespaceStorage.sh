#!/usr/bin/env bash

. setEnvVars.sh

echo "Be sure that there is a working EFS cluster before proceeding"
if [[ $# -lt 1 ]]
then
  echo "Please specify the efs id as the first argument to this script"
else
  echo "Configuring EFS with kubernetes"

  sed "s/EFS_ID/$1/g" test_efs_template.yaml > test_efs.yaml

  kubectl create namespace $NAMESPACE
  kubectl --namespace=$NAMESPACE apply -f test_efs.yaml
  kubectl --namespace=$NAMESPACE apply -f test_efs_claim.yaml
  echo "EFS configuration complete"
  echo "Next, install JupyterHub"
fi
