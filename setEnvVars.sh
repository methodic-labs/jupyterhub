#!/usr/bin/env bash

REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}')
ZONES=$(aws ec2 describe-availability-zones --region "$REGION" | grep ZoneName | awk '{print $2}' | tr -d '"')

export REGION
export ZONES
export KOPS_STATE_STORE=s3://kube-test-cluster-config
export NAME=kube-test-jupyterhub.k8s.local
export RELEASE=jupyterhub
export NAMESPACE=jupyterhub
export PV_NAME=efs-persist
