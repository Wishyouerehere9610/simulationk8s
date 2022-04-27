# gitea
* CName: `gitea-ops.lab.zjvis.net` `k8s-01.lab.zjvis.net`

## install gitea
1. prepare [gitea.values.yaml](resources/gitea.values.yaml.md)
   + modify `gitea.config.mailer.PASSWD`
2. prepare images
   + ```shell
     DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
     BASE_URL="https://resource.static.zjvis.net/docker-images"
     for IMAGE in "docker.io_gitea_gitea_1.15.3.dim" \
            "docker.io_bitnami_memcached_1.6.9-debian-10-r114.dim" \
            "docker.io_bitnami_memcached-exporter_0.8.0-debian-10-r105.dim" \
            "docker.io_bitnami_postgresql_11.11.0-debian-10-r62.dim" \
            "docker.io_bitnami_bitnami-shell_10.dim " \
            "docker.io_bitnami_postgres-exporter_0.9.0-debian-10-r34.dim"
     do
        IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
        if [ ! -f $IMAGE_FILE ]; then
            TMP_FILE=$IMAGE_FILE.tmp \
                && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                && mv $TMP_FILE $IMAGE_FILE
        fi
        docker image load -i $IMAGE_FILE
     done
     DOCKER_REGISTRY="docker-registry-ops.lab.zjvis.net:32443"
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
3. create `gitea-admin-secret`
   + ```shell
     # uses the "Array" declaration
     # referencing the variable again with as $PASSWORD an index array is the same as ${PASSWORD[0]}
     kubectl get namespace application \
         || kubectl create namespace application
     PASSWORD=($((echo -n $RANDOM | md5sum 2>/dev/null) || (echo -n $RANDOM | md5 2>/dev/null)))
     # NOTE: username should have at least 6 characters
     kubectl -n application \
         create secret generic gitea-admin-secret \
         --from-literal=username=gitea_admin \
         --from-literal=password=$PASSWORD
     ```
4. install with helm
   + ```shell
     helm install \
         --create-namespace --namespace application \
         my-gitea \
         https://resource.static.zjvis.net/charts/dl.gitea.io/charts/gitea-4.1.1.tgz \
         --values gitea.values.yaml \
         --atomic
     ```      

## test
1. check connection
   * ```shell
     curl --insecure --header 'Host: gitea-ops.lab.zjvis.net' https://localhost
     ```
2. visit gitea via website
   * visit `https://gitea-ops.lab.zjvis.net` with your browser
   * with your browser
     + ```shell
       kubectl -n application get secret gitea-admin-secret -o jsonpath="{.data.username}" | base64 --decode && echo
       kubectl -n application get secret gitea-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo
       ```
   * login as admin user
   * create repository named `test-repo`
   * add ssh public key(step omit)
3. modify haproxy
   + add `1022` map `32022`
4. visit gitea via ssh
    * ```shell
      git config --global user.email "youemail@example.com"
      git config --global user.name "Your Name"
      
      touch 开源问题留存.md
      git init
      git checkout -b main
      git add 开源问题留存.md
      git commit -m "first commit"
      git remote add origin ssh://git@gitea-ops.lab.zjvis.net:1022/gitea_admin/test-repo.git
      git push -u origin main
      ```
5. test email feature by creating a user and sending notification email to the user

## uninstallation
* uninsall `gitea`
    * ```shell
      helm -n application uninstall my-gitea \
          && kubectl -n application delete pvc data-my-gitea-0 data-my-gitea-postgresql-0 \
          && kubectl -n application delete secret gitea-admin-secret
      ```
