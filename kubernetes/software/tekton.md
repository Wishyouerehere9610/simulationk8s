# tekton

## main usage

* none

## conceptions

* none

## purpose
* none

## pre-requirements
* [create local cluster for testing](../create.local.cluster.with.kind.md)
* [ingress](../basic/ingress.nginx.md)
* [cert-manager](../basic/cert.manager.md)

## Do it

1. prepare [verdaccio.values.yaml](resources/verdaccio.values.yaml.md)
2. prepare images
    * ```shell  
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
      BASE_URL="https://resource.cnconti.cc/docker-images"
      LOCAL_IMAGE="localhost:5000"
      for IMAGE in "docker.io/gcr.io/tekton-releases/dogfooding/tkn:latest-20220304" \
         "docker.io/gcr.io/tekton-releases/github.com/tektoncd/operator/cmd/kubernetes/proxy-webhook:v0.54.0" \
         "docker.io/gcr.io/tekton-releases/github.com/tektoncd/operator/cmd/kubernetes/operator:v0.54.0" \
         "docker.io/gcr.io/tekton-releases/github.com/tektoncd/operator/cmd/kubernetes/webhook:v0.54.0" 
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
2. prepare images
    * ```shell  
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p ${DOCKER_IMAGE_PATH}
      BASE_URL="https://resource.cnconti.cc/docker-images"
      LOCAL_IMAGE="localhost:5000"
      for IMAGE in "docker.io/gcr.io/tekton-releases/github.com/tektoncd/dashboard/cmd/dashboard:v0.23.0" \
         "docker.io/gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint:v0.32.0" \
         "docker.io/gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/kubeconfigwriter:v0.32.0" \
         "docker.io/gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.32.0" \
         "docker.io/gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/nop:v0.32.0" \
         "docker.io/gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/imagedigestexporter:v0.32.0" \
         "docker.io/gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/pullrequest-init:v0.32.0" \
         "docker.io/gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/controller:v0.32.0" \
         "docker.io/gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/webhook:v0.32.0" \
         "docker.io/gcr.io/tekton-releases/github.com/tektoncd/triggers/cmd/controller:v0.18.0" \
         "docker.io/gcr.io/tekton-releases/github.com/tektoncd/triggers/cmd/webhook:v0.18.0" \
         "docker.io/gcr.io/tekton-releases/github.com/tektoncd/triggers/cmd/eventlistenersink:v0.18.0" \
         "docker.io/gcr.io/tekton-releases/github.com/tektoncd/triggers/cmd/interceptors:v0.18.0"
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
3. create `verdaccio-secret`
    * ```shell
     # uses the "Array" declaration
     # referencing the variable again with as $PASSWORD an index array is the same as ${PASSWORD[0]}
     PASSWORD=($((echo -n $RANDOM | md5sum 2>/dev/null) || (echo -n $RANDOM | md5 2>/dev/null)))
     # NOTE: username should have at least 6 characters
     kubectl -n application \
         create secret generic verdaccio-secret \
         --from-literal=username=admin \
         --from-literal=password=$PASSWORD \
     # username & password
     kubectl -n application get secret verdaccio-secret -o jsonpath={.data.username} | base64 --decode && echo
     kubectl -n application get secret verdaccio-secret -o jsonpath={.data.password} | base64 --decode && echo
     ```
4. install by helm
    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-verdaccio \
          https://conti-charts.oss-cn-hangzhou.aliyuncs.com/github.com/verdaccio/charts/releases/download/verdaccio-4.6.2/verdaccio-4.6.2.tgz \
          --values verdaccio.values.yaml \
          --atomic
      ```
