#!/usr/bin/env bash

scp -i ~/aws/openlattice-aws-gc.pem ec2-user@ec2-160-1-131-93.us-gov-west-1.compute.amazonaws.com:/home/ec2-user/.kube/config ~/kubecfgs/
