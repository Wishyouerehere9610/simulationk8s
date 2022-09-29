# nginx

## isntallation
1. prepare [default.conf](resources/default.conf.md)
2. run `nginx`
    * ```shell
      docker run --rm \
          -p 8080:80 \
          -v $(pwd)/data:/usr/share/nginx/html:ro \
          -v $(pwd)/default.conf:/etc/nginx/conf.d/default.conf:ro \
          -d nginx:1.19.9-alpine
      ```

## test
1. visit http://localhost:8080
