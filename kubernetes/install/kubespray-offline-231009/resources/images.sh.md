```shell
#!/bin/bash

CURRENT_DIR=$(cd $(dirname $0); pwd)
IMAGE_DIR="${CURRENT_DIR}"
IMAGE_LIST="${IMAGE_DIR}/images.list"
LOCALHOST_NAME=$(hostname)

set -e

if [ -f /etc/docker/daemon.json ];then
    set -e 
    cp /etc/docker/daemon.json /etc/docker/daemon.json.$(date +%s).bak  
    echo "{ \"insecure-registries\":[\"$LOCALHOST_NAME:5000\"] }" > /etc/docker/daemon.json
else    
    echo "{ \"insecure-registries\":[\"$LOCALHOST_NAME:5000\"] }" > /etc/docker/daemon.json
fi

systemctl restart docker

while read -r line; do
    FILE_NAME="$(echo ${line} | sed s@"/"@"-"@g | sed s/":"/"-"/g)".dim
    new_image="${LOCALHOST_NAME}:5000/${line}"
    org_image=$(sudo docker load -i ${IMAGE_DIR}/${FILE_NAME} | head -n1 | awk '{print $3}')
    image_id=$(sudo docker image inspect ${org_image} | grep "\"Id\":" | awk -F: '{print $3}'| sed s/'\",'//)
    if [ -z "${FILE_NAME}" ]; then
        echo "Failed to get file_name for line ${line}"
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
    sudo docker load -i ${IMAGE_DIR}/${FILE_NAME}
    sudo docker tag  ${image_id} ${new_image}
    sudo docker push ${new_image}
done <<< "$(cat ${IMAGE_LIST})"

echo "Succeeded to register container images to local registry."
echo "Please specify ${LOCALHOST_NAME}:5000 for the following options in your inventry:"
echo "- kube_image_repo"
echo "- gcr_image_repo"
echo "- docker_image_repo"
echo "- quay_image_repo"
```