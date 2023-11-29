## cert-manager

### installation
1. prepare [cert.manager.values.yaml](resources/cert.manager.values.yaml.md)
2. prepare images at every node
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops.lab.zjvis.net:32443/docker-images"
      for IMAGE in "quay.io_jetstack_cert-manager-controller_v1.5.4.dim" \
          "quay.io_jetstack_cert-manager-webhook_v1.5.4.dim" \
          "quay.io_jetstack_cert-manager-cainjector_v1.5.4.dim" \
          "quay.io_jetstack_cert-manager-ctl_v1.5.4.dim" \
          "quay.io_jetstack_cert-manager-acmesolver_v1.5.4.dim" \
          "ghcr.io_devmachine-fr_cert-manager-alidns-webhook_cert-manager-alidns-webhook_0.2.0.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE 
          fi
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      ```
3. install `cert-manager`
    * ```shell
      helm install \
          --create-namespace --namespace basic-components \
          my-cert-manager \
          https://resource-ops.lab.zjvis.net:32443/charts/charts.jetstack.io/cert-manager-v1.5.4.tgz \
          --values cert.manager.values.yaml \
          --atomic
      ```
4. install `alidns-webhook`
    * prepare [alidns.webhook.values.yaml](resources/alidns.webhook.values.yaml.md)
    * make sure permissions added to `$YOUR_ACCESS_KEY_ID`
        + ```json
          {
            "Version": "1",
            "Statement": [
              {
                "Effect": "Allow",
                "Action": [
                  "alidns:AddDomainRecord",
                  "alidns:DeleteDomainRecord"
                ],
                "Resource": "acs:alidns:*:*:domain/zjvis.net"
              }, {
                "Effect": "Allow",
                "Action": [
                  "alidns:DescribeDomains",
                  "alidns:DescribeDomainRecords"
                ],
                "Resource": "acs:alidns:*:*:domain/*"
              }
            ]
          }
          ```
    * create secret of `alidns-webhook-secrets`
        + ```shell
          kubectl -n basic-components create secret generic alidns-webhook-secrets \
              --from-literal="access-token=$YOUR_ACCESS_KEY_ID" \
              --from-literal="secret-key=$YOUR_ACCESS-KEY-SECRET"
          ```
    * ```shell
      helm install \
          --create-namespace --namespace basic-components \
          my-alidns-webhook \
          https://resource-ops.lab.zjvis.net:32443/charts/github.com/DEVmachine-fr/cert-manager-alidns-webhook/releases/download/alidns-webhook-0.6.0/alidns-webhook-0.6.0.tgz \
          --values alidns.webhook.values.yaml \
          --atomic
      ```
5. create cluster issuer
    * prepare [alidns.webhook.cluster.issuer.yaml](resources/alidns.webhook.cluster.issuer.yaml.md)
    * ```shell
      kubectl -n basic-components apply -f alidns.webhook.cluster.issuer.yaml
      ```
