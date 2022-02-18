# gitea

## main usage

* service for git repositories

## conceptions

* none

## practise

### pre-requirements

* none

### purpose

* prepare a kind cluster with basic components
* install gitea

### do it
1. install gitea
    * prepare [gitea.values.yaml](gitea/gitea.values.yaml.md)
    * prepare images
        + ```shell
          DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
          BASE_URL="https://resource.static.zjvis.net/docker-images"
          for IMAGE in "gitea/gitea:1.15.3" \
                  "docker.io/bitnami/memcached:1.6.9-debian-10-r114" \
                  "docker.io/bitnami/memcached-exporter:0.8.0-debian-10-r105" \
                  "docker.io/bitnami/postgresql:11.11.0-debian-10-r62" \
                  "docker.io/bitnami/bitnami-shell:10" \
                  "docker.io/bitnami/postgres-exporter:0.9.0-debian-10-r34"
          do
              IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
              if [ ! -f $IMAGE_FILE ]; then
                  TMP_FILE=$IMAGE_FILE.tmp \
                      && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                      && mv $TMP_FILE $IMAGE_FILE
              fi
              docker image load -i $IMAGE_FILE
          done
          DOCKER_REGISTRY="docker-registry-ops-test.lab.zjvis.net:32443"
          for IMAGE in "gitea/gitea:1.15.3" \
                  "docker.io/bitnami/memcached:1.6.9-debian-10-r114" \
                  "docker.io/bitnami/memcached-exporter:0.8.0-debian-10-r105" \
                  "docker.io/bitnami/postgresql:11.11.0-debian-10-r62" \
                  "docker.io/bitnami/bitnami-shell:10" \
                  "docker.io/bitnami/postgres-exporter:0.9.0-debian-10-r34"
          do
              DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
              docker tag $IMAGE $DOCKER_TARGET_IMAGE \
                  && docker push $DOCKER_TARGET_IMAGE \
                  && docker image rm $DOCKER_TARGET_IMAGE
          done
          ```
    * create `gitea-admin-secret`
        + ```shell
          # uses the "Array" declaration
          # referencing the variable again with as $PASSWORD an index array is the same as ${PASSWORD[0]}
          ./bin/kubectl get namespace application \
              || ./bin/kubectl create namespace application
          PASSWORD=($((echo -n $RANDOM | md5sum 2>/dev/null) || (echo -n $RANDOM | md5 2>/dev/null)))
          # NOTE: username should have at least 6 characters
          ./bin/kubectl -n application \
              create secret generic gitea-admin-secret \
              --from-literal=username=gitea_admin \
              --from-literal=password=$PASSWORD
          ```
    * install with helm
        + ```shell
          ./bin/helm install \
              --create-namespace --namespace application \
              my-gitea \
              gitea \
              --version 4.1.1 \
              --repo https://dl.gitea.io/charts \
              --values confluence.values.yaml \
              --atomic
          ```

5. visit gitea from website
    * port-forward
        + ```shell
          ./bin/kubectl --namespace application port-forward svc/my-gitea-http 3000:3000 --address 0.0.0.0
          ```
    * visit http://$HOST:3000
    * password
        + ```shell
          ./bin/kubectl get secret gitea-admin-secret -n gitea -o jsonpath={.data.password} | base64 --decode && echo
          ```

6. visit gitea from SSH

    * port-forward

        + ```shell
          ./bin/kubectl --namespace application port-forward svc/my-gitea-ssh 222:22 --address 0.0.0.0
          ```

    * 创建测试仓库

        * ```tex
          在网页上创建测试库(用户创建)
          ```

    + 测试ssh链接是否正常

        * ```shell
          git clone ssh://git@192.168.31.31:222/libokang/test.git
          ```
 
storage:
    storageClassDeviceSets:
      - name: set1
        count: 7
        portable: false
        tuneDeviceClass: true
        tuneFastDeviceClass: false
        encrypted: false
        placement:
          topologySpreadConstraints:
            - maxSkew: 1
              topologyKey: kubernetes.io/hostname
              whenUnsatisfiable: ScheduleAnyway
              labelSelector:
                matchExpressions:
                  - key: app
                    operator: In
                    values:
                      - rook-ceph-osd
        preparePlacement:
          podAntiAffinity:
            preferredDuringSchedulingIgnoredDuringExecution:
              - weight: 100
                podAffinityTerm:
                  labelSelector:
                    matchExpressions:
                      - key: app
                        operator: In
                        values:
                          - rook-ceph-osd
                      - key: app
                        operator: In
                        values:
                          - rook-ceph-osd-prepare
                  topologyKey: kubernetes.io/hostname
          topologySpreadConstraints:
            - maxSkew: 1
              topologyKey: kubernetes.io/hostname
              whenUnsatisfiable: DoNotSchedule
              labelSelector:
                matchExpressions:
                  - key: app
                    operator: In
                    values:
                      - rook-ceph-osd-prepare
        resources:
        # These are the OSD daemon limits. For OSD prepare limits, see the separate section below for "prepareosd" resources
        #   limits:
        #     cpu: "500m"
        #     memory: "4Gi"
        #   requests:
        #     cpu: "500m"
        #     memory: "4Gi"
        volumeClaimTemplates:
          - metadata:
              name: data
            spec:
              resources:
                requests:
                  storage: 1500Gi
              storageClassName: rook-data
              volumeMode: Block
              accessModes:
                - ReadWriteOnce
    onlyApplyOSDPlacement: false
  resources:
  disruptionManagement:
    managePodBudgets: true
    osdMaintenanceTimeout: 30
    pgHealthCheckTimeout: 0
    manageMachineDisruptionBudgets: false