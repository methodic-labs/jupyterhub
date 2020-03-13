#!/usr/bin/env bash

. setEnvVars.sh

helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update

PROXY_TOKEN="$(openssl rand -hex 32)"
sed "s/PROXY_TOKEN/$PROXY_TOKEN/g" helm_config_template.yaml > config.yaml

# maybe run certbot to generate a cert and dns-cloudflare plugin to update DNS to point to the IP we get here
# certbot certonly --dns-cloudflare --dns-cloudflare-credentials ~/.secrets/certbot/cloudflare.ini --dns-cloudflare-propagation-seconds 60 -d jupyterhub.openlattice.com

helm upgrade --install "$RELEASE" jupyterhub/jupyterhub --namespace "$NAMESPACE" --version=0.8.2 --values config.yaml

kubectl config set-context "$(kubectl config current-context)" --namespace "$NAMESPACE"

kubectl get pod

echo "Jupyterhub starting up"

time until kubectl get service; do sleep 15; done

kubectl get svc proxy-public

echo "Jupyterhub should be started up now"

time until kubectl get service; do sleep 15; done

IP=$(kubectl get svc proxy-public | tail -n 1 | awk '{ print $3 }')
PORTS=$(kubectl get svc proxy-public | tail -n 1 | awk '{ print $5 }' | sed 's/\,/\n/g')
HOSTNAME=$(kubectl get svc proxy-public | tail -n 1 | awk '{ print $4 }')

echo "You should now be able to interact with Jupyterhub at $HOSTNAME or $IP on the following ports:"
printf '%s\n' "${PORTS[@]}"

# singleuser:
  # image:
    # Eventually we'll want to use our own image in order to use our Python API
    # Get the latest image tag at:
    # https://hub.docker.com/r/jupyter/datascience-notebook/tags/
    # Inspect the Dockerfile at:
    # https://github.com/jupyter/docker-stacks/tree/master/datascience-notebook/Dockerfile
    # name: jupyter/datascience-notebook
    # tag: 63d0df23b673
  # image:
    # name: jupyter/datascience-notebook
    # tag: notebook-6.0.3
