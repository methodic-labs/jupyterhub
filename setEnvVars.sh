#!/usr/bin/env bash

export KOPS_STATE_STORE=s3://openlattice-jupyterhub-crpc-private
export KOPS_CLUSTER_NAME=openlattice-jupyterhub.k8s.local
export RELEASE=jupyterhub
export NAMESPACE=jupyterhub
export PV_NAME=efs-persist
