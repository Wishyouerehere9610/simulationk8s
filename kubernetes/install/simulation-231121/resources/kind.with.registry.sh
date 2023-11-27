#!/bin/sh
set -o errexit

KIND_CLUSTER_CONFIGURATION=${1:-kind.cluster.yaml}
KIND_BINARY=${2:-kind}
KUBECTL_BINARY=${3:-kubectl}
KIND_IMAGE=${4:-kindest/node:v1.23.3}

docker inspect $KIND_IMAGE > /dev/null 2>&1 || docker pull $KIND_IMAGE
$KIND_BINARY create cluster --image $KIND_IMAGE --config=${KIND_CLUSTER_CONFIGURATION}
