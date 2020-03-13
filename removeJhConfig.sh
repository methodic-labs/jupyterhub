#!/usr/bin/env bash

. setEnvVars.sh

helm delete $NAMESPACE --purge
