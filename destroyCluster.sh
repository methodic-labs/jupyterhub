#!/usr/bin/env bash

. setEnvVars.sh

helm delete "$NAMESPACE" --purge

kubectl delete namespace "$NAMESPACE"

kubectl delete persistentvolume "$PV_NAME"

kops delete cluster "$CLUSTER_NAME" --yes

rm config.yaml

rm test_efs.yaml
