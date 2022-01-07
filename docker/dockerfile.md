# dockerfile

* FROM
  * ```dockerfile
    FROM centos:7.6
    RUN echo '这是一个本地构建的nginx镜像' > /usr/share/nginx/html/index.html
    ```
* RUN
  * ```dockerfile
    # shell
    RUN /bin/bash echo $?
    # exec
    RUN ["/bin/bash", "echo", "$?"]
    ```
  * Dockerfile 的指令每执行一次都会在 docker 上新建一层。所以过多无意义的层，会造成镜像膨胀过大
    * ```dockerfile
      RUN yum -y install wget \
          && wget -O redis.tar.gz "http://download.redis.io/releases/redis-5.0.3.tar.gz" \
          && tar -xvf redis.tar.gz
      ```
* COPY
  * ```dockerfile
    COPY [--chown=<user>:<group>] <源路径1>...  <目标路径>
    COPY [--chown=<user>:<group>] ["<源路径1>",...  "<目标路径>"]
    ```
* ADD
  * ```dockerfile
    ADD dir file url
    ```
* CMD
  * 仅最后一个生效
  * ```dockerfile
    # shell
    CMD /bin/bash echo $?
    # exec
    CMD ["/bin/bash", "echo", "$?"]
    ```
* ENTRYPOINT
  * 仅最后一个生效
  * ```dockerfile
    ENTRYPOINT ["<executeable>","<param1>","<param2>",...]
    ```
* ENV
  * 镜像构建以及镜像构建成功后也可以使用
  * ```dockerfile
    ENV <key> <value>
    ENV <key1>=<value1> <key2>=<value2>
    ```
* ARG
  * 只能在镜像构建中使用
  * ```dockerfile
    ARG <key>=<default>
    ```
* VOLUME
  * -v 参数修改挂在
  * ```dockerfile
    VOLUME ["/data", "/data"]
    VOLUME /data
    ```
* EXPOSE
  * 声明端口作用
  * ```dockerfile
    EXPOSE 22
    ```
* WORKDIR 
  * ```dockerfile
    WORKDIR /home
    ```
* USER
  * ```dockerfile
    USER root:root
    ```
* HEALTHCHECK
  * ```dockerfile
    HEALTHCHECK [选项] CMD <命令>：设置检查容器健康状况的命令
    HEALTHCHECK NONE：如果基础镜像有健康检查指令，使用这行可以屏蔽掉其健康检查指令
    
    HEALTHCHECK [选项] CMD <命令> : 这边 CMD 后面跟随的命令使用，可以参考 CMD 的用法。
    ```
* ONBUILD
  * ```dockerfile
    ONBUILD <>
    ```
* LABEL
  * ```dockerfile
    LABEL <key>=<value> <key>=<value> <key>=<value>
    ```

























