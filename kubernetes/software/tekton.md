# tekton

## main usage

* none

## conceptions

* none

## purpose
* none

## pre-requirements
* [create.local.cluster.with.kind](/kubernetes/create.local.cluster.with.kind.md)
* [ingress-nginx](../basic/ingress.nginx.md)
* [cert-manager](../basic/cert.manager.md)
* [docker-registry](../basic/docker.registry.md)

## do it
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      # BASE_URL="https://resource-ops-test.lab.zjvis.net:32443/docker-images"
      BASE_URL="https://resource.cnconti.cc/docker-images"
      for IMAGE in "docker.io_gcr.io_tekton-releases_dogfooding_tkn_latest-025de2.dim" \
          "docker.io_gcr.io_tekton-releases_github.com_tektoncd_operator_cmd_kubernetes_proxy-webhook_v0.54.0.dim" \
          "docker.io_gcr.io_tekton-releases_github.com_tektoncd_operator_cmd_kubernetes_operator_v0.54.0.dim" \
          "docker.io_gcr.io_tekton-releases_github.com_tektoncd_operator_cmd_kubernetes_webhook_v0.54.0.dim" \
          "docker.io_busybox_1.33.1-uclibc.dim" \
          "docker.io_bitnami_git_2.35.1-debian-10-r44.dim" \
          "docker.io_docker_20.10.13-dind-alpine3.15.dim" \
          "docker.io_alpine_3.15.0.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      DOCKER_REGISTRY="insecure.docker.registry.local:80"
      for IMAGE in "docker.io/gcr.io/tekton-releases/dogfooding/tkn:latest-025de2" \
          "docker.io/gcr.io/tekton-releases/github.com/tektoncd/operator/cmd/kubernetes/proxy-webhook:v0.54.0" \
          "docker.io/gcr.io/tekton-releases/github.com/tektoncd/operator/cmd/kubernetes/operator:v0.54.0" \
          "docker.io/gcr.io/tekton-releases/github.com/tektoncd/operator/cmd/kubernetes/webhook:v0.54.0" \
          "docker.io/busybox:1.33.1-uclibc" \
          "docker.io/bitnami/git:2.35.1-debian-10-r44" \
          "docker.io/docker:20.10.13-dind-alpine3.15" \
          "docker.io/alpine:3.15.0"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
2. prepare images
    * ```shell  
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      # BASE_URL="https://resource-ops-test.lab.zjvis.net:32443/docker-images"
      BASE_URL="https://resource.cnconti.cc/docker-images"
      for IMAGE in "docker.io_gcr.io_tekton-releases_github.com_tektoncd_pipeline_cmd_entrypoint_v0.32.0.dim" \
          "docker.io_gcr.io_tekton-releases_github.com_tektoncd_dashboard_cmd_dashboard_v0.23.0.dim" \
          "docker.io_gcr.io_tekton-releases_github.com_tektoncd_pipeline_cmd_kubeconfigwriter_v0.32.0.dim" \
          "docker.io_gcr.io_tekton-releases_github.com_tektoncd_pipeline_cmd_git-init_v0.32.0.dim" \
          "docker.io_gcr.io_tekton-releases_github.com_tektoncd_pipeline_cmd_nop_v0.32.0.dim" \
          "docker.io_gcr.io_tekton-releases_github.com_tektoncd_pipeline_cmd_imagedigestexporter_v0.32.0.dim" \
          "docker.io_gcr.io_tekton-releases_github.com_tektoncd_pipeline_cmd_pullrequest-init_v0.32.0.dim" \
          "docker.io_gcr.io_tekton-releases_github.com_tektoncd_pipeline_cmd_controller_v0.32.0.dim" \
          "docker.io_gcr.io_tekton-releases_github.com_tektoncd_triggers_cmd_controller_v0.18.0.dim" \
          "docker.io_gcr.io_tekton-releases_github.com_tektoncd_pipeline_cmd_webhook_v0.32.0.dim" \
          "docker.io_gcr.io_tekton-releases_github.com_tektoncd_triggers_cmd_webhook_v0.18.0.dim" \
          "docker.io_gcr.io_tekton-releases_github.com_tektoncd_triggers_cmd_eventlistenersink_v0.18.0.dim" \
          "docker.io_gcr.io_tekton-releases_github.com_tektoncd_triggers_cmd_interceptors_v0.18.0.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE \
      done
      for IMAGE in "docker.io/gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint:v0.32.0" \
          "docker.io/gcr.io/tekton-releases/github.com/tektoncd/dashboard/cmd/dashboard:v0.23.0" \
          "docker.io/gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/kubeconfigwriter:v0.32.0" \
          "docker.io/gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.32.0" \
          "docker.io/gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/nop:v0.32.0" \
          "docker.io/gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/imagedigestexporter:v0.32.0" \
          "docker.io/gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/pullrequest-init:v0.32.0" \
          "docker.io/gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/controller:v0.32.0" \
          "docker.io/gcr.io/tekton-releases/github.com/tektoncd/triggers/cmd/controller:v0.18.0" \
          "docker.io/gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/webhook:v0.32.0" \
          "docker.io/gcr.io/tekton-releases/github.com/tektoncd/triggers/cmd/webhook:v0.18.0" \
          "docker.io/gcr.io/tekton-releases/github.com/tektoncd/triggers/cmd/eventlistenersink:v0.18.0" \
          "docker.io/gcr.io/tekton-releases/github.com/tektoncd/triggers/cmd/interceptors:v0.18.0"
      do
          kind load docker-image $IMAGE
      done
      ```
3. install `tekton-operator`
    * prepare [tekton_operator_v0.54.0_release.yaml](resources/tekton_operator_v0.54.0_release.yaml.md)
      * ```shell
        kubectl -n tekton-operator apply -f tekton_operator_v0.54.0_release.yaml
        ```
    * wait for pods to be ready
      * ```shell
        kubectl -n tekton-operator wait --for=condition=ready pod --all
        ```
4. apply `tekton.config` 
    * prepare [tekton.config.yaml](resources/tekton.config.yaml.md)
    * ```shell
      kubectl -n tekton-operator apply -f tekton.config.yaml
      ```
5. apply ` tekton.ingress`
    * prepare [tekton.ingress.yaml](resources/tekton.ingress.yaml.md)
    * ```shell
      kubectl get namespace tekton-pipelines \
          && kubectl -n tekton-pipelines apply -f tekton.ingress.yaml
      ```

### test
1. check connection
    * ```shell
      echo '127.0.0.1 tekton-dashboard.local' >> /etc/host \ 
          && curl --insecure --header 'Host: tekton-dashboard.local' https://localhost
      ```
    * visit `https://tekton-dashboard.local`
2. prepare `test` namespace
    * ```shell
      kubectl get namespace test > /dev/null 2>&1 || kubectl create namespace test
      ```
3. test `task`
    * prepare [tekton.build.task.yaml](resources/tekton.build.task.yaml.md)
    * prepare [tekton.build.task.run.yaml](resources/tekton.build.task.run.yaml.md)
      * ```shell
        kubectl -n test apply -f tekton.build.task.yaml \
            && kubectl -n test create -f tekton.build.task.run.yaml
        ```
    * checkt `taskRun` by visiting `https://tekton-dashboard.local/#/taskruns`
4. test `pipeline`
    * create `ssh-key-secret` secret
      * ```shell
        kubectl -n test create secret generic git-ssh-key-secret \
            --from-file=${HOME}/.ssh/ -o yaml --dry-run=client \
            | kubectl -n test apply -f -
        ```
    * prepare [tekton.pipeline.yaml](resources/tekton.pipeline.yaml.md)
    * prepare [tekton.pipeline.run.yaml](resources/tekton.pipeline.run.yaml.md)
      * ```shell
       kubectl -n test apply -f tekton.pipeline.yaml \
           && kubectl -n test create -f tekton.pipeline.run.yaml
       ```
    * checkt `taskRun` by visiting `https://tekton-dashboard.local/#/pipelineruns`

### uninstallation
1. delete `task` `taskrun` `pipeline` `pipelinerun`
    * ```shell
      kubectl -n test delete -f tekton.pipeline.run.yaml \
          && kubectl -n test delete -f tekton.pipeline.yaml \
          && kubecrl -n test delete -f tekton.build.task.run.yaml \
          && kubecrl -n test delete -f tekton.build.task.yaml
      ```
2. delete ingress `tekton-dashboard-ingress`
    * ```shell
      kubectl -n tekton-pipelines delete ingress tekton-dashboard-ingress
      ```
3. delete secret `git-ssh-key-secret`
    * ```shell
      kubectl -n test delete secret git-ssh-key-secret
      ```
4. delete `tekton.config`
    * ```shell
      kubectl -n tekton-operator delete -f tekton.config.yaml
      ```
5. uninstall `tekton-operator`
    * NOTE: This step has the problem of unclean uninstallation
    * ```shell
      kubectl -n tekton-operator delete -f tekton_operator_v0.54.0_release.yaml \
          && kubectl delete ns test tekton-pipelines tekton-operator
      ```  
