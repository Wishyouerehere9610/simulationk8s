* ```Dockerfile
  ARG DOCKER_REGISTRY=docker.io
  FROM ${DOCKER_REGISTRY}/nginx:1.19.9-alpine
  
  ADD dist/ /usr/share/nginx/html/
  
  EXPOSE 80
  
  CMD ["nginx", "-g", "daemon off;"]
  ```