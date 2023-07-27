## mysql

### installation
1. prepare images
    * ```shell
      docker pull docker.io/bitnami/mysql:5.7.43-debian-11-r8 
      # docker pull docker.io/bitnami/mysql:8.0.34-debian-11-r8
      ```
2. install `mysql` by docker
    * ```shell
      mkdir -p ${PWD}/data/mysql \
      && chown 1001 ${PWD}/data/mysql \
      && chmod 777 ${PWD}/data/mysql \
      && docker run \
             --name mysql \
             --restart always \
             -p 3306:3306 \
             -e MYSQL_ROOT_PASSWORD=123456 \
             -e ALLOW_EMPTY_PASSWORD=yes \
             -v ${PWD}/data/mysql:/bitnami/mysql \
             -d docker.io/bitnami/mysql:5.7.43-debian-11-r8 
      ```
3. test `mysql`
    * ```shell
      docker exec -ti mysql bash -c 'echo "show databases" | mysql -u root'
      ```

