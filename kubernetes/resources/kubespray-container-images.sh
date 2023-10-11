#!/bin/bash

CURRENT_DIR=$(cd $(dirname $0); pwd)

IMAGE_TAR_FILE="${CURRENT_DIR}/kubespray-images.tar.gz"
IMAGE_DIR="${CURRENT_DIR}/container-images"
IMAGE_LIST="${IMAGE_DIR}/container-images.txt"
RETRY_COUNT=5

set +e

sudo docker container inspect registry >/dev/null 2>&1

if [ $? -ne 0 ]; then
	sudo docker run --restart=always -d -p 5000:5000 --name registry docker.io/library/registry:2.8.1
fi

set -e

while read -r line; do
	file_name=$(echo ${line} | awk '{print $1}')
	raw_image=$(echo ${line} | awk '{print $2}')
	new_image="${LOCALHOST_NAME}:5000/${raw_image}"
	org_image=$(sudo docker load -i ${IMAGE_DIR}/${file_name} | head -n1 | awk '{print $3}')
	image_id=$(sudo docker image inspect ${org_image} | grep "\"Id\":" | awk -F: '{print $3}'| sed s/'\",'//)
	if [ -z "${file_name}" ]; then
		echo "Failed to get file_name for line ${line}"
		exit 1
	fi
	if [ -z "${raw_image}" ]; then
		echo "Failed to get raw_image for line ${line}"
		exit 1
	fi
	if [ -z "${org_image}" ]; then
		echo "Failed to get org_image for line ${line}"
		exit 1
	fi
	if [ -z "${image_id}" ]; then
		echo "Failed to get image_id for file ${file_name}"
		exit 1
	fi
	sudo docker load -i ${IMAGE_DIR}/${file_name}
	sudo docker tag  ${image_id} ${new_image}
	sudo docker push ${new_image}
done <<< "$(cat ${IMAGE_LIST})"

echo "Succeeded to register container images to local registry."
echo "Please specify ${LOCALHOST_NAME}:5000 for the following options in your inventry:"
echo "- kube_image_repo"
echo "- gcr_image_repo"
echo "- docker_image_repo"
echo "- quay_image_repo"