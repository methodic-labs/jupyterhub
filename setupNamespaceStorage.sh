#!/usr/bin/env bash

. setEnvVars.sh

if [[ $# -lt 1 ]]
then
  echo "specify the efs id"
else
  sed "s/EFS_ID/$1/g" test_efs_template.yaml > test_efs.yaml

  kubectl create namespace $NAMESPACE
  kubectl --namespace=$NAMESPACE apply -f test_efs.yaml
  kubectl --namespace=$NAMESPACE apply -f test_efs_claim.yaml
fi
