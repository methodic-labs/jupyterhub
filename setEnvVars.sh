#!/usr/bin/env bash

export AWS_REGION=us-gov-west-1
export KOPS_STATE_STORE=s3://kube-test-cluster-config
export CLUSTER_NAME=kube-test-jupyterhub.k8s.local
export RELEASE=jupyterhub
export NAMESPACE=jupyterhub
export PV_NAME=efs-persist
