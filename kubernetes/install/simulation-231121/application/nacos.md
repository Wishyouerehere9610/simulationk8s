## nacos

### precondition
* [mariadb](../middleware/mariadb.md)

### installation
1. prepare images
    * ```shell
      DOCKER_IMAGE_PATH=/root/docker-images && mkdir -p $DOCKER_IMAGE_PATH
      BASE_URL="https://resource-ops-dev.lab.zjvis.net:32443/docker-images"
      for IMAGE in "docker.io_nacos_nacos-server_v2.2.0.dim"
      do
          IMAGE_FILE=$DOCKER_IMAGE_PATH/$IMAGE
          if [ ! -f $IMAGE_FILE ]; then
              TMP_FILE=$IMAGE_FILE.tmp \
                  && curl -o "$TMP_FILE" -L "$BASE_URL/$IMAGE" \
                  && mv $TMP_FILE $IMAGE_FILE
          fi
          docker image load -i $IMAGE_FILE && rm -f $IMAGE_FILE
      done
      DOCKER_REGISTRY="docker-registry-simulation.lab.zjvis.net:32443"
      for IMAGE in "docker.io/nacos/nacos-server:v2.2.0"
      do
          DOCKER_TARGET_IMAGE=$DOCKER_REGISTRY/$IMAGE
          docker tag $IMAGE $DOCKER_TARGET_IMAGE \
              && docker push $DOCKER_TARGET_IMAGE \
              && docker image rm $DOCKER_TARGET_IMAGE
      done
      ```
2. create database `nacos`
    * ```shell
      kubectl -n middleware exec -it deployment/mariadb-tool -- bash -c \
          'echo "create database nacos" | mysql -h my-mariadb.middleware -uroot -p$MARIADB_ROOT_PASSWORD'
      ```
3. prepare initialization `mariadb`
    * initialization `nacos` use [nacos.initialize.mariadb.20230320.sql](resources/nacos.initialize.mariadb.20230320.sql.md)
    * ```shell
      POD_NAME=$(kubectl get pod -n middleware -l "app.kubernetes.io/name=mariadb-tool" -o jsonpath="{.items[0].metadata.name}") \
      && export SQL_FILENAME="nacos.initialize.mariadb.20230320.sql" \
      && kubectl -n middleware cp ${SQL_FILENAME} ${POD_NAME}:/tmp/${SQL_FILENAME} \
      && kubectl -n middleware exec -it ${POD_NAME} -- bash -c \
             "mysql -h my-mariadb.middleware -uroot -p\${MARIADB_ROOT_PASSWORD} nacos < /tmp/nacos.initialize.mariadb.20230320.sql"
      ```
4. Obtain `mariadb` password
    * ```shell
      kubectl get secret --namespace middleware my-mariadb \
             -o jsonpath="{.data.mariadb-root-password}" | base64 --decode && echo
      ```
5. prepare helm values（reset mariadb password） [nacos.values.yaml](resources/nacos.values.yaml.md)
6. install `nacos` by helm
    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-nacos \
          https://resource-ops.lab.zjvis.net/charts/ygqygq2.github.io/charts/nacos-2.1.4.tgz \
          --values nacos.values.yaml \
          --timeout 1200s \
          --atomic
      ```

### test
1. connect to `nacos`
    * `http://nacos-simulation.cnconti.cc/nacos`
    * username: `nacos`
    * password: `Nacos@1234`
2. `nacos` create namespace
    * ![img.png](img.png)
3. `nacos` create Configuration
    * Query `middleware & password` and modify content
    * ![img_1.png](img_1.png)
4. configuration example
   * ```
     server:
  port: 8289
  servlet:
    session:
      timeout: 3600

spring:
  application:
    name: simulation
  servlet:
    multipart:
      max-request-size: 1GB
      max-file-size: 200MB
  jackson:
    time-zone: GMT+8
  mvc:
    async:
      request-timeout: 600000
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource
    druid:
      driver-class-name: com.mysql.cj.jdbc.Driver
      url: jdbc:mysql://my-mariadb.middleware:3306/simulation?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true&serverTimezone=Asia/Shanghai
      username: root
      password: 8p9MXdFxdv
      filters: config
      initial-size: 10
      max-active: 20
      max-wait: 5000
      time-between-eviction-runs-millis: 30000
      min-evictable-idle-time-millis: 100000
      test-while-idle: true
      test-on-borrow: true
      test-on-return: false
      pool-prepared-statements: true
      max-pool-prepared-statement-per-connection-size: 10
  redis:
    cluster:
      nodes: my-redis-cluster.middleware:6379
      max-redirects: 3
    database: 1
    jedis:
      pool:
        max-active: 100 
        max-idle: 8 
        min-idle: 2 
        max-wait: -1 
    password: 74PyLDEJhM
    timeout: 500

mybatis:
  mapper-locations: classpath*:mapper/*.xml
  type-aliases-package: org.zjvis.simulation.common.dto
  configuration:
    map-underscore-to-camel-case: true
  type-handlers-package: org.zjvis.simulation.common.handler

pagehelper:
  helperDialect: mysql
  reasonable: true
  supportMethodsArguments: true
  params: count=countSql
  returnPageInfo: check



jasypt:
  encryptor:
    password: 4tr=Kl34jDs@O/u4_#2c

jwt:
  secret: 32e4bc02a7ccf34d72692db7f08aa945102e290beb4832d5673b987015d8cb4f



minio:
  endpoint: my-minio.middleware
  port: 9000
  accessKey: admin
  secretKey: xfW1uRCnNS


async:
  threadPool:
    corePoolSize: 20
    maxPoolSize: 100
    queueCapacity: 1000
    keepAliveSeconds: 60
    threadNamePrefix: Async-Thread-

group:
  threadPool:
    corePoolSize: 20
    maxPoolSize: 100
    queueCapacity: 1000
    keepAliveSeconds: 60
    threadNamePrefix: Group-Thread-
  poolNum: 5
  poolBalanceLoad: ThreadPoolRoundRobin

swagger:
  enable: true

cache:
  guava:
    cacheMaximumMemory: 10GB
    concurrency: 16
    cacheMaximumSize: 150
    expireTime: 604800
  threadPool:
    corePoolSize: 100
    maxPoolSize: 300
    queueCapacity: 10000
    keepAliveSeconds: 60
    threadNamePrefix: Load-Cache-Thread-

process:
  num: 0
  debugPort: 50000
  jmxRemotePort: 51000
  cmdArgs: "{\"-Xmx\":\"-Xmx4096m\", \"-Xms\":\"-Xms512m\"}"
  
management:
  metrics:
    export:
      influx:
        enabled: true
        db: simulation
        uri: http://my-influxdb.middleware:8086
        user-name: admin
        password: bZ6qCx2UdM
        connect-timeout: 1s
        read-timeout: 10s
        auto-create-db: true
        step: 1m
        num-threads: 2
        consistency: one
        compressed: true
        batch-size: 1000
### uninstall
1. uninstall `my-nacos`
    * ```shell
      helm -n application uninstall my-nacos
      ```
    
