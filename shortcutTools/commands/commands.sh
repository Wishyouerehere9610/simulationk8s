# 镜像库localhost:5000
for IMAGE in "conti2021.icu/sshd:0.1.4" 
do
    LOCAL_IMAGE="localhost:5000/$IMAGE"
    docker image inspect $IMAGE || docker pull $IMAGE
    docker image tag $IMAGE $LOCAL_IMAGE
    docker push $LOCAL_IMAGE
done


# docker build
docker build -t conti2021/test:0.1.1 .




    # prepare directories




    IMAGE_FILE_DIRECTORY_AT_HOST=docker-images/$TOPIC_DIRECTORY
    IMAGE_FILE_DIRECTORY_AT_QEMU_MACHINE=/root/docker-images/$TOPIC_DIRECTORY
    mkdir -p $IMAGE_FILE_DIRECTORY_AT_HOST
    SSH_OPTIONS="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
    ssh $SSH_OPTIONS -p 10022 root@localhost "mkdir -p $IMAGE_FILE_DIRECTORY_AT_QEMU_MACHINE"

    for IMAGE_FILE in $IMAGE_LIST
    do
        IMAGE_FILE_AT_HOST=docker-images/$TOPIC_DIRECTORY/$IMAGE_FILE
        IMAGE_FILE_AT_QEMU_MACHINE=$IMAGE_FILE_DIRECTORY_AT_QEMU_MACHINE/$IMAGE_FILE
        if [ ! -f $IMAGE_FILE_AT_HOST ]; then
            TMP_FILE=$IMAGE_FILE_AT_HOST.tmp
            curl -o $TMP_FILE -L ${BASE_URL}/$TOPIC_DIRECTORY/$IMAGE_FILE
            mv $TMP_FILE $IMAGE_FILE_AT_HOST
        fi
        scp $SSH_OPTIONS -P 10022 $IMAGE_FILE_AT_HOST root@localhost:$IMAGE_FILE_AT_QEMU_MACHINE \
            && ssh $SSH_OPTIONS -p 10022 root@localhost "docker image load -i $IMAGE_FILE_AT_QEMU_MACHINE"
    done
}


while read remote; 
do 
    echo ${remote}
done < `ls`

































































