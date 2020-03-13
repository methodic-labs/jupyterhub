#!/usr/bin/env bash

. setEnvVars.sh

kops edit cluster $CLUSTER_NAME
