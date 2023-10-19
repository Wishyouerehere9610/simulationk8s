#!/bin/bash

CURRENT_DIR=$( dirname "$(readlink -f "$0")" )
OFFLINE_FILES_DIR_NAME="data"
OFFLINE_FILES_DIR="${CURRENT_DIR}/${OFFLINE_FILES_DIR_NAME}"
NGINX_PORT=8080

[ -n "$NO_HTTP_SERVER" ] && echo "skip to run nginx" && exit 0

# run nginx container server
if command -v nerdctl 1>/dev/null 2>&1; then
    runtime="nerdctl"
elif command -v podman 1>/dev/null 2>&1; then
    runtime="podman"
elif command -v docker 1>/dev/null 2>&1; then
    runtime="docker"
else
    echo "No supported container runtime found"
    exit 1
fi

sudo "${runtime}" container inspect nginx >/dev/null 2>&1
if [ $? -ne 0 ]; then
    sudo "${runtime}" run \
        --name kubespray-nginx \
        --restart=always -p ${NGINX_PORT}:80 \
        --volume "${OFFLINE_FILES_DIR}:/usr/share/nginx/html/download" \
        --volume "${CURRENT_DIR}"/nginx.conf:/etc/nginx/nginx.conf \
        -d docker.io/library/nginx:1.25.2-alpine
fi
