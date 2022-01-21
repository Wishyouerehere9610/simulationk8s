### requirements

1. jdk 8
2. docker engine (linux/amd64)
3. k8s cluster connected with kubectl
4. docker clients configured with a docker registry(`docker-registry-test.lab.zjvis.net:32500`)

### usage

1. clone `aiworks` and `nebula` to `/root/git_projects/`
    * ```shell
      git clone --single-branch --branch feature/graph_deploy git@git.zjvis.org:bigdata/aiworks.git
      git clone --single-branch --branch nebula-base git@git.zjvis.org:bigdata/nebula.git
      ```
2. configure `/etc/hosts` at every k8s node
    * ```shell
      echo 10.105.20.20 resource.static.zjvis.net >> /etc/hosts
      ```
3. install main board
    * ```shell
      IP_ADDRESS_OF_KIND_HOST=10.101.16.72
      cd /root/git_projects/aiworks/deploy
      export HOST_IP=$IP_ADDRESS_OF_KIND_HOST \
          && export KIND_BASE_URL=https://resource.static.zjvis.net/binary/kind \
          && export KUBECTL_BASE_URL=https://resource.static.zjvis.net/binary/kubectl \
          && export HELM_BASE_URL=https://resource.static.zjvis.net/binary/helm \
          && export PUBLISH_ENV=test \
          && export DOCKER_REGISTRY=docker-registry-test.lab.zjvis.net:32500 \
          && export PLUGIN_DOCKER_REGISTRY_OUTER=docker-registry-test.lab.zjvis.net:32500 \
          && export PLUGIN_DOCKER_REGISTRY_INNER=docker-registry-test.lab.zjvis.net:32500 \
          && export DIND_DAEMON=docker-registry-test.lab.zjvis.net:32500 \
          && export PULL_POLICY=Always \
          && export INITIALIZE=true \
          && ./gradlew :backendDeploy \
          && export FRONTEND_SOURCE_HOME=/root/git_projects/nebula \
          && ./gradlew :frontendDeploy
      ```
4. push base images before installing the plugin named `graph-analysis`
    * ```shell
      for IMAGE in "docker.io/bitnami/cassandra:3.11.11-debian-10-r4" \
          "docker.io/openjdk:8u312-jdk-oraclelinux8" \
          "docker.io/nginx:1.17.10-alpine"
      do
          LOCAL_IMAGE="docker-registry-test.lab.zjvis.net:32500/$IMAGE"
          docker image inspect $IMAGE || docker pull $IMAGE
          docker image tag $IMAGE $LOCAL_IMAGE
          docker push $LOCAL_IMAGE
      done
      ```
5. visit `http://k8s-test-01.lab.zjvis.net:32080`
    * username: `test-nebula`
    * password: `nebula@2021`

### how to connect to database

* run mysql client
    + ```shell script
      alias kubectl=./build/runtime/bin/kubectl
      ROOT_PASSWORD=$(kubectl get secret --namespace middleware my-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
      kubectl run my-mariadb-client --rm --tty -i --restart='Never' --env ROOT_PASSWORD=$ROOT_PASSWORD --image docker-registry-test.lab.zjvis.net:32500/docker.io/bitnami/mariadb:10.5.12-debian-10-r0 --command -- bash
      ```
* connect aiworks-database
    + ```shell script
      mysql -h my-mariadb.middleware -uroot -p$ROOT_PASSWORD aiworks
      ```

### how to check logs

1. fetch pod id
    * take `nebula-ce-backend` in `nebula` namespace as example
    * ```shell
      alias kubectl=./build/runtime/bin/kubectl
      export POD_NAME=$(kubectl get pod -n nebula -l "app.kubernetes.io/name=nebula-ce-backend,app.kubernetes.io/instance=nebula-ce-backend" -o jsonpath="{.items[0].metadata.name}")
      ```
2. show logs
    * show all logs
        + ```shell
          # take some pod in nebula namespace as example
          kubectl -n nebula logs $POD_NAME -c nebula-ce-backend
          ```
    * show logs from now on and just read last 20 lines
        + ```shell
          kubectl -n nebula logs $POD_NAME -c nebula-ce-backend -f --tail 20
          ```
    * plugin logs
        + ```shell
          kubectl -n nebula exec -it $POD_NAME -c nebula-ce-backend -- tail -f /tmp/pluginInstall.log
          ```
        + ```shell
          kubectl -n nebula exec -it $POD_NAME -c nebula-ce-backend -- tail -f /tmp/pluginUninstall.log
          ```

### how to jump into container

1. fetch pod id
    * take `nebula-ce-backend` in `nebula` namespace as example
    * ```shell
      alias kubectl=./build/runtime/bin/kubectl
      export POD_NAME=$(kubectl get pod -n nebula -l "app.kubernetes.io/name=nebula-ce-backend,app.kubernetes.io/instance=nebula-ce-backend" -o jsonpath="{.items[0].metadata.name}")
      ```
2. jump into with `bash` or `sh`
    * ```shell
      kubectl -n nebula exec -it $POD_NAME -c nebula-ce-backend bash
      # kubectl -n nebula exec -it $POD_NAME -c nebula-ce-backend sh
      # exploring just like as if login an operating system
      ```

### how to upgrade

* upgrade backend
    + ```shell
      export HOST_IP=$IP_ADDRESS_OF_KIND_HOST \
          && export KIND_BASE_URL=https://resource.static.zjvis.net/binary/kind \
          && export KUBECTL_BASE_URL=https://resource.static.zjvis.net/binary/kubectl \
          && export HELM_BASE_URL=https://resource.static.zjvis.net/binary/helm \
          && export PUBLISH_ENV=test \
          && export DOCKER_REGISTRY=docker-registry-test.lab.zjvis.net:32500 \
          && export PLUGIN_DOCKER_REGISTRY_OUTER=docker-registry-test.lab.zjvis.net:32500 \
          && export PLUGIN_DOCKER_REGISTRY_INNER=docker-registry-test.lab.zjvis.net:32500 \
          && export DIND_DAEMON=docker-registry-test.lab.zjvis.net:32500 \
          && export PULL_POLICY=Always \
          && export INITIALIZE=true \
          && ./gradlew :backendUpgrade
      ```
* upgrade frontend
    + ```shell
      # TODO remove FRONTEND_SOURCE_HOME
      export HOST_IP=$IP_ADDRESS_OF_KIND_HOST \
          && export KIND_BASE_URL=https://resource.static.zjvis.net/binary/kind \
          && export KUBECTL_BASE_URL=https://resource.static.zjvis.net/binary/kubectl \
          && export HELM_BASE_URL=https://resource.static.zjvis.net/binary/helm \
          && export PUBLISH_ENV=test \
          && export DOCKER_REGISTRY=docker-registry-test.lab.zjvis.net:32500 \
          && export PLUGIN_DOCKER_REGISTRY_OUTER=docker-registry-test.lab.zjvis.net:32500 \
          && export PLUGIN_DOCKER_REGISTRY_INNER=docker-registry-test.lab.zjvis.net:32500 \
          && export DIND_DAEMON=docker-registry-test.lab.zjvis.net:32500 \
          && export PULL_POLICY=Always \
          && export FRONTEND_SOURCE_HOME=/root/git_projects/nebula \
          && ./gradlew :frontendUpgrade
      ```

### how to clean up

* remove k8s cluster
    + ```shell
      helm -n graph-analysis uninstall graph-analysis-cassandra
      helm -n nebula uninstall nebula-ce-backend
      helm -n nebula uninstall nebula-ce-frontend
      helm -n middleware uninstall my-mariadb
      helm -n middleware uninstall my-minio
      helm -n middleware uninstall my-redis-cluster
      helm -n middleware uninstall my-ingress
      kubectl -n graph-analysis delete pvc data-graph-analysis-cassandra-0
      kubectl -n middleware delete pod my-minio-tool
      kubectl -n middleware delete pvc data-my-mariadb-0 redis-data-my-redis-cluster-0 redis-data-my-redis-cluster-1 redis-data-my-redis-cluster-2 redis-data-my-redis-cluster-3 redis-data-my-redis-cluster-4 redis-data-my-redis-cluster-5
      ```
