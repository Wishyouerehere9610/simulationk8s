# ELK-stack

## install
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource.cnconti.cc/docker-images"
      for IMAGE in "docker.io_docker.elastic.co_elasticsearch_elasticsearch_7.16.3.dim" \
          "docker.io_docker.elastic.co_kibana_kibana_7.16.3.dim" \
          "docker.io_docker.elastic.co_beats_filebeat_7.16.3.dim" \
          "docker.io_febbweiss_java-log-generator_latest.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE
      done
      DOCKER_REGISTRY="docker-registry-local.cnconti.cc:32443"
      for IMAGE in "docker.io/docker.elastic.co/elasticsearch/elasticsearch:7.16.3" \
          "docker.io/docker.elastic.co/kibana/kibana:7.16.3" \
          "docker.io/docker.elastic.co/beats/filebeat:7.16.3" \
          "docker.io/febbweiss/java-log-generator:latest"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
2. install `elasticsearch`
    * prepare [elasticsearch.values.yaml](resource/elasticsearch.values.yaml.md)
    * install by helm
      * ```shell
        helm install \
            --create-namespace --namespace monitor \
            my-elasticsearch \
            https://resource.cnconti.cc/charts/helm.elastic.co/elasticsearch-7.16.3.tgz \
            --values elasticsearch.values.yaml \
            --atomic
        ```
    * check connection
      * ```shell
         curl --insecure --header 'Host: elasticsearch-local.cnconti.cc' https://localhost
         ```
3. install `kibana`
    * prepare [kibana.values.yaml](resource/kibana.values.yaml.md)
    * install by helm
       * ```shell
         helm install \
             --create-namespace --namespace monitor \
             my-kibana \
             https://resource.cnconti.cc/charts/helm.elastic.co/kibana-7.16.3.tgz \
             --values kibana.values.yaml \
             --atomic
         ```
    * check connection
       * ```shell
          curl --insecure --header 'Host: kibana-local.cnconti.cn' https://localhost
          ```
4. install `filebeat`
   * prepare [filebeat.values.yaml](resource/filebeat.values.yaml.md)
   * install by helm
      * ```shell
         helm install \
             --create-namespace --namespace monitor \
             my-filebeat \
             https://resource.cnconti.cc/charts/helm.elastic.co/filebeat-7.16.3.tgz \
             --values filebeat.values.yaml \
             --atomic
         ```
   * filebeat.values.yaml \
      * ```shell
          kubectl -n monitor wait --for=condition=ready pod --all
          ```

## test
1. check connection 
    * ```shell
      curl --insecure --header 'Host: grafana-ops-test.lab.zjvis.net' https://localhost
      ```
   * ```shell
      curl --insecure --header 'Host: prometheus-ops-test.lab.zjvis.net' https://localhost
      ```
    * visit `https://grafana-ops-test.lab.zjvis.net`
    * check `Node Exporter/*` to figure out the status of nodes in k8s cluster
    * check `Kubernetes/*` to figure out the status of k8s cluster
3. prepare `test` namespace
    * ```shell
      kubectl get namespace test > /dev/null 2>&1 || kubectl create namespace test
      ```
4. install `mariadb` 
    * NOTE: metrics feature enabled
    * prepare [mariadb.values.yaml](resource/mariadb.values.yaml.md)
    * install by helm
      * ```shell
        helm install \
            --create-namespace --namespace test \
            mariadb-for-test \
            https://resource-ops-test.lab.zjvis.net/charts/charts.bitnami.com/bitnami/mariadb-9.4.2.tgz \
            --values mariadb.values.yaml \
            --atomic
        ```
5. add `Prometheus` instance
    * prepare [service.account.for.test.yaml](resource/service.account.for.test.yaml.md)
      * ```shell
        kubectl -n test apply -f service.account.for.test.yaml
        ```
    * prepare [prometheus.for.test.yaml](resource/prometheus.for.test.yaml.md)
      * ```shell
        kubectl -n test apply -f prometheus.for.test.yaml
        ```
    * wait for prometheus to be ready
      * ```shell
        kubectl -n test wait --for=condition=ready pod --all
        ```
    * visit `http://prometheus-test-ops-test.lab.zjvis.net` to check prometheus service ready
6. add `ServiceMonitor` instance
    * prepare [service.monitor.for.test.yaml](resource/service.monitor.for.test.yaml.md)
      * ```shell
        kubectl -n test apply -f service.monitor.for.test.yaml
        ```
7. operation `grafana`
    * configure `test-prometheus` as a new datasource to grafana
      * name = `test-prometheus`
      * http.url = `http://prometheus-operated.test:9090`
      * keep other configuration the same as defaults
      * click `Save & Test`
    * import dashboard to grafana
      * prepare [mysql.mixin.dashboard.grafana.json](resource/mysql.mixin.dashboard.grafana.json.md)
      * import `mysql.mixin.dashboard.grafana.json` to dashboard
      * now you can check the dashboard named `MySQL Exporter Quickstart and Dashboard`
        * select `test-prometheus` as `datasource`

## uninstallation
1. delete ` service account`,`test-prometheus` and `ServiceMonitor`
    * ```shell
      kubectl -n test delete -f service.monitor.for.test.yaml
      kubectl -n test delete -f prometheus.for.test.yaml
      kubectl -n test delete -f service.account.for.test.yaml
      kubectl -n test delete pvc prometheus-test-prometheus-db-prometheus-test-prometheus-0
      ```
2. uninstall `mariadb`
    * ```shell
      helm -n test uninstall mariadb-for-test
      kubectl -n test delete pvc data-mariadb-for-test-0
      ```
3. uninstall `kube-prometheus-stack`
    * ```shell
       helm -n monitor uninstall my-kube-prometheus-stack
       kubectl -n monitor delete pvc alertmanager-my-kube-prometheus-stack-alertmanager-db-alertmanager-my-kube-prometheus-stack-alertmanager-0
       kubectl -n monitor delete pvc prometheus-my-kube-prometheus-stack-prometheus-db-prometheus-my-kube-prometheus-stack-prometheus-0
       # NOTE: my-kube-prometheus-stack-grafana will be deleted automatically after uninstallation of my-kube-prometheus-stack
       #kubectl -n monitor delete pvc my-kube-prometheus-stack-grafana
      ```