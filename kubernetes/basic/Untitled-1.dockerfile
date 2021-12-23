TOPIC_DIRECTORY="cert.manager.basic"
BASE_URL="localhost:5000"
download_and_load $TOPIC_DIRECTORY $BASE_URL \
    "quay.io/jetstack/cert-manager-webhook:v1.5.4" \
    "quay.io/jetstack/cert-manager-cainjector:v1.5.4" \
    "quay.io/jetstack/cert-manager-ctl:v1.5.4"



SSH_OPTIONS="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
ssh $SSH_OPTIONS -p 1022 root@localhost 