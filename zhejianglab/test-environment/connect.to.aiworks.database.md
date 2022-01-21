### connect to aiworks-database

* get mysql password
    + ```shell script
      ROOT_PASSWORD=$(kubectl get secret --namespace middleware my-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
      ```
* run mysql client
    + ```shell script
      kubectl run my-mariadb-client --rm --tty -i --restart='Never' --env ROOT_PASSWORD=$ROOT_PASSWORD --image  docker-registry-test.lab.zjvis.net:32500/docker.io/bitnami/mariadb:10.5.12-debian-10-r0 --command -- bash
      ```
* connect aiworks-database
    + ```shell script
      mysql -h my-mariadb.middleware -uroot -p$ROOT_PASSWORD aiworks
      ```
