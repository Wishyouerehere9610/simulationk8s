# cert manager

## main usage
* create certification of ssl automatically by cert-manager
* use dns01 method

## conceptions
* none

## purpose
* create a kubernetes cluster by kind
* setup cert-manager
* setup alidns-webhook
* install nginx service and access it with https

## pre-requirements

* [local.cluster.for.testing](../resources/local.cluster.for.testing.md)
* [install ingress-nginx](ingress.nginx.md)

## Do it
1. prepare [cert.manager.values.yaml](resources/cert.manager.values.yaml.md)
2. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
      BASE_URL="https://resource.cnconti.cc/docker-images"
      LOCAL_IMAGE="localhost:5000"
      for IMAGE in "quay.io/jetstack/cert-manager-controller:v1.5.4" \
          "quay.io/jetstack/cert-manager-webhook:v1.5.4" \
          "quay.io/jetstack/cert-manager-cainjector:v1.5.4" \
          "quay.io/jetstack/cert-manager-ctl:v1.5.4"
      do
          IMAGE_FILE=$(echo ${IMAGE} | sed "s/\//_/g" | sed "s/\:/_/g").dim
          LOCAL_IMAGE_FIEL=${DOCKER_IMAGE_PATH}/${IMAGE_FILE}
          if [ ! -f ${LOCAL_IMAGE_FIEL} ]; then
              curl -o ${IMAGE_FILE} -L ${BASE_URL}/${IMAGE_FILE} \
                  && mv ${IMAGE_FILE} ${LOCAL_IMAGE_FIEL} \
                  || rm -rf ${IMAGE_FILE}
          fi
          docker image load -i ${LOCAL_IMAGE_FIEL} && rm -rf ${LOCAL_IMAGE_FIEL}
          docker image inspect ${IMAGE} || docker pull ${IMAGE}
          docker image tag ${IMAGE} ${LOCAL_IMAGE}/${IMAGE}
          docker push ${LOCAL_IMAGE}/${IMAGE}
      done
      ```
3. install by helm
    * ```shell
       helm install \
           --create-namespace --namespace basic-components \
           my-cert-manager \
           https://resource.cnconti.cc/charts/charts.jetstack.io/cert-manager-v1.5.4.tgz \
           --values cert.manager.values.yaml \
           --atomic
       ```
4. install `alidns-webhook`
   * prepare [alidns.webhook.values.yaml](resources/alidns.webhook.values.yaml.md)
   * make sure permissions added to `$YOUR_ACCESS_KEY_ID`
     * ```json
       {
         "Version": "1",
         "Statement": [
           {
             "Effect": "Allow",
             "Action": [
               "alidns:AddDomainRecord",
               "alidns:DeleteDomainRecord"
             ],
             "Resource": "acs:alidns:*:*:domain/cnconti.cc"
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
     * ```shell
       kubectl -n basic-components create secret generic alidns-webhook-secrets \
           --from-literal="access-token=${YOUR_ACCESS_KEY_ID}" \
           --from-literal="secret-key=${YOUR_ACCESS_KEY_SECRET}"
       ```
   * install by helm
     + ```shell
       helm install \
           --create-namespace --namespace basic-components \
           my-alidns-webhook \
           https://resource.static.zjvis.net/charts/alidns-webhook-0.6.0.tgz \
           --values alidns.webhook.values.yaml \
           --atomic
       ```
5. create `clusterissuer`
   * prepare [alidns.webhook.clusterissuer.yaml](resources/alidns.webhook.clusterissuer.yaml.md)
     * ```shell
       kubectl -n basic-components apply -f alidns.webhook.cluster.issuer.yaml
       ```
## Test

      
      