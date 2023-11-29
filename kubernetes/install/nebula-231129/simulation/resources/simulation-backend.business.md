* Dockerfile
    + ```dockerfile
      FROM docker.io/cnconti/oraclejdk:simulation-r1
      
      COPY simulation.jar /app/application.jar
      COPY entry-point.sh /app/entry-point.sh
      
      RUN chmod u+x /app/entry-point.sh
      
      WORKDIR /app
      CMD ["/app/entry-point.sh"]
      ```
* entry-point.sh
    + ```shell
      #!/bin/bash
      APPLICATION_YAML_PATH=${APPLICATION_YAML_PATH:-/app/application.yaml}
      JAVA_OPS=${JAVA_OPS:--server -Xmx4096m -Xms1024m}
      if [ -f "$APPLICATION_YAML_PATH" ]; then
          exec java $JAVA_OPS -jar /app/application.jar --spring.config.location=file:${APPLICATION_YAML_PATH}
      else
        echo "file $APPLICATION_YAML_PATH not exists"
        exit -1
      fi
      ```