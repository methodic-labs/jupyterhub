#!/usr/bin/env bash

. setEnvVars.sh

helm delete "$NAMESPACE" --purge

kubectl delete namespace "$NAMESPACE"

kubectl delete persistentvolume "$PV_NAME"

kops delete cluster "$KOPS_CLUSTER_NAME" --yes
