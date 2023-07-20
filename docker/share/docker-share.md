## Docker

### Docker简介
Docker是一个开源的应用容器引擎，基于go语言开发并遵循了apache2.0协议开源。

开发者可以打包自己的应用到容器里面，然后发布到任何流行的linux服务器，实现快速部署。容器是完全使用沙箱机制，相互之间不会有任何接口（类iphone的app），并且容器开销极其低。

简单的理解，docker就是一个软件集装箱化平台，就像船只、火车、卡车运输集装箱而不论其内部的货物一样，软件容器充当软件部署的标准单元，其中可以包含不同的代码和依赖项。

按照这种方式容器化软件，开发人员和 IT 专业人员只需进行极少修改或不修改，即可将其部署到不同的环境，如果出现的故障，也可以通过镜像，快速恢复服务。


### Docker基本概念
* `Client（客户端）`
    + ```text
      是Docker的用户端，可以接受用户命令和配置标识，并与Docker daemon通信。
      ```
* `Images（镜像）` 
    + ```text
      docker镜像就是一个只读模板，比如，一个镜像可以包含一个完整的centos，里面仅安装apache或用户的其他应用，镜像可以用来创建docker容器，
      另外docker提供了一个很简单的机制来创建镜像或者更新现有的镜像，用户甚至可以直接从其他人那里下周一个已经做好的镜像来直接使用
      ```
* `Containers（容器）`
    + ```text
      docker利用容器来运行应用，容器是从镜像创建的运行实例，它可以被启动，开始、停止、删除、每个容器都是互相隔离的，保证安全的平台
      可以把容器看做是要给简易版的linux环境（包括root用户权限、镜像空间、用户空间和网络空间等）和运行再其中的应用程序
      ```
* `Registry（仓库）`
    + ```text
      仓库是集中存储镜像文件的沧桑，registry是仓库主从服务器，实际上参考注册服务器上存放着多个仓库，每个仓库中又包含了多个镜像，每个镜像有不同的标签（tag）。
      
      仓库分为两种，公有参考，和私有仓库，最大的公开仓库是docker Hub，存放了数量庞大的镜像供用户下周，国内的docker pool，这里仓库的概念与Git类似，registry可以理解为github这样的托管服务。
      ```
    
### Docker优势
* 容器与虚拟机对比
| 特性 | 容器 | 虚拟机 |
|--|-----|-----|
| 启动 | 秒级 | 分钟级 |
| 硬盘使用 | 一般为 MB | 一般为GB |
| 性能 | 接近原生 | 弱于原生 |
| 系统支持量 | 单机支持上千个容器 | 一般为几十个 |
* 容器越来越受欢迎的原因
    + 灵活：即使是最复杂的应用也可以容器化。
    + 轻量级：容器利用并共享宿主机内核。
    + 可互换：可以随时部署更新和升级。
    + 便携式：可以在本地构建，在任何地方部署和运行。
    + 可扩展：可以增加并自动分发容器副本。

### dokcer 的基本命令
* ```shell
  ### 查看镜像
  docker images
  
  ### 查看容器
  docker ps # running Containers
  docker ps -a # all Containers
  
  ### 启动容器 docker run --help
  docker run --name test busybox:1.35.0-uclibc
  
  ### 停止容器
  docker stop test
  
  ### 删除容器
  docker rm test
  
  ### 删除镜像
  docker rmi busybox:1.35.0-uclibc
  ```

### 案例一
* 使用docker的方式完成gradle build 的过程(输入为代码文件，输出为jar文件)
    + ```shell
      docker run \
          --rm -it \
          -v ${PWD}:/app \
          --workdir /app \
          openjdk:11.0.14.1-jdk-bullseye \
         ./gradlew backend:simulation:buildBinary
      ```

### 案例二
* 使用docker的方式 启动一个mariadb数据库
    + ```shell
      docker run --rm \
          --name mysql-server \
          -p 3307:3306 \
          -e MYSQL_ROOT_PASSWORD=master_root_password \
          -e MYSQL_DATABASE=my_database \
          -d bitnami/mysql:5.7.43-debian-11-r0
      ```
    + ```shell
      docker run --rm \
          --name mysql-server \
          -e MYSQL_ROOT_PASSWORD=master_root_password \
          -e MYSQL_DATABASE=my_database \
          bitnami/mysql:8.0.34-
      ```

### 案例三
* 本地启动一个正常执行的simulation代码，构建一个镜像，迁移到其他机器上运行
    + ```shell
      pass
      ```
    


