#!/usr/bin/env bash

. setEnvVars.sh

kubectl delete namespace "$NAMESPACE"

kubectl delete persistentvolume "$PV_NAME"

kops delete cluster "$CLUSTER_NAME" --yes

rm config.yaml

rm test_efs.yaml
