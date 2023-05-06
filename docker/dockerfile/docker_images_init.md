## docker image init

### ubuntu
* ```dockerfile
  # BASIC_IMAGE_LIST = ["18.04", "20.04", "22.04"]
  FROM ubuntu:18.04
  
  RUN sed -i -E 's/(archive|security).ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list \
      && apt update && apt install -y vim curl 
  ```

### debian
* ```dockerfile
  # BASIC_IMAGE_LIST = ["buster", "bullseye"]
  FROM debian:buster
  
  RUN sed -i -E 's/(deb|security).debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
      && apt update && apt install -y vim curl 
  ```
  
### alpine
* ```dockerfile
  FROM alpine:3.15.0
  
  RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
      && apk update && apk add vim curl
  ```
