#!/usr/bin/env bash

. setEnvVars.sh

echo "Installing JupyterHub using Helm"

helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update

helm upgrade --cleanup-on-fail \
 --install "$RELEASE" jupyterhub/jupyterhub \
 --namespace="$NAMESPACE" \
 --version=1.1.3 --values config.yaml

kubectl config set-context "$(kubectl config current-context)" --namespace "$NAMESPACE"

kubectl get pod

echo "Jupyterhub starting up; Please create EFS cluster and appropriate security groups"

time until kubectl get service; do sleep 15; done

kubectl get svc proxy-public

sleep 60
echo "Jupyterhub should be started up now"

IP=$(kubectl get svc proxy-public | tail -n 1 | awk '{ print $3 }')
PORTS=$(kubectl get svc proxy-public | tail -n 1 | awk '{ print $5 }' | sed 's/\,/\n/g')
HOSTNAME=$(kubectl get svc proxy-public | tail -n 1 | awk '{ print $4 }')

echo "You should now be able to interact with Jupyterhub at $HOSTNAME or $IP on the following ports:"
printf '%s\n' "${PORTS[@]}"

echo "JupyterHub installation complete"

# SSL cert generation will fail until DNS is updated with load balancer service and autohttps is restarted