# gitea

## main usage

* service for git repositories

## conceptions

* none

## purpose

* prepare a kind cluster with basic components
* install gitea

## pre-requirements
* [create local cluster for testing](../create.local.cluster.with.kind.md)
* [ingress](../basic/ingress.nginx.md)
* [cert-manager](../basic/cert.manager.md)

## Do it
1. prepare [gitea.values.yaml](resources/gitea.values.yaml.md)
2. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource.static.zjvis.net/docker-images"
      for IMAGE in "gitea_gitea_1.16.6.dim" \
          "docker.io_bitnami_mariadb_10.5.12-debian-10-r0.dim" \
          "docker.io_bitnami_bitnami-shell_10-debian-10-r153.dim" \
          "docker.io_bitnami_mysqld-exporter_0.13.0-debian-10-r56.dim" \
          "docker.io_bitnami_phpmyadmin_5.1.1-debian-10-r147.dim" \
          "docker.io_bitnami_apache-exporter_0.10.1-debian-10-r54.dim"
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
      for IMAGE in "gitea/gitea:1.16.6"
          "docker.io/bitnami/mariadb:10.5.12-debian-10-r0" \
          "docker.io/bitnami/bitnami-shell:10-debian-10-r153" \
          "docker.io/bitnami/mysqld-exporter:0.13.0-debian-10-r56" \
          "docker.io/bitnami/phpmyadmin:5.1.1-debian-10-r147" \
          "docker.io/bitnami/apache-exporter:0.10.1-debian-10-r54"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
3. create `gitea-admin-secret`
    * ```shell
      # uses the "Array" declaration
      # referencing the variable again with as $PASSWORD an index array is the same as ${PASSWORD[0]}
      kubectl get namespace application || kubectl create namespace application
      PASSWORD=($((echo -n $RANDOM | md5sum 2>/dev/null) || (echo -n $RANDOM | md5 2>/dev/null)))
      # NOTE: username should have at least 6 characters
      kubectl -n application \
          create secret generic gitea-admin-secret \
          --from-literal=username=gitea_admin \
          --from-literal=password=$PASSWORD
      ```
4. install with helm
    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-gitea \
          https://resource.cnconti.cc/charts/dl.gitea.io/charts/gitea-4.1.1.tgz \
          --values gitea.values.yaml \
          --atomic
      ```

## Test
1. check connection
    * ```shell
      curl --insecure --header 'Host: gitea.local.com' https://localhost
      ```
2. visit gitea via website
    * visit `https://gitea.local.com` with your browser
    * with your browser
      + ```shell
        kubectl -n application get secret gitea-admin-secret -o jsonpath="{.data.username}" | base64 --decode && echo
        kubectl -n application get secret gitea-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo
        ```
    * login as admin user
    * create repository named `test-repo`
    * add ssh public key(step omit)
3. visit gitea via ssh
    + ```shell
      git config --global user.email "youemail@example.com"
      git config --global user.name "Your Name"
      
      touch README.md
      git init
      git checkout -b main
      git add README.md
      git commit -m "first commit"
      git remote add origin ssh://git@gitea.local.com:1022/gitea_admin/test-repo.git
      git push -u origin main
      ```
4. test email feature by creating a user and sending notification email to the user
5. visit `https://gitea.local.com`

### uninstall
1. uninstall `gitea`
    * ```shell
      helm -n application uninstall my-gitea \
          && kubectl -n application delete pvc data-my-gitea-0 data-my-gitea-postgresql-0 \
          && kubectl -n application delete secret gitea-admin-secret
      ```