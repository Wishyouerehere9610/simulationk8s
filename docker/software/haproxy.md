# haproxy

## installation
1. prepare [haproxy.cfg](resources/haproxy.cfg.md)
2. dokcer run `haproxy`
    * ```shell
      docker run --rm \
          -p 443:443 \
          -p 80:80 \
          -restart always \
          -v $(pwd)/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro \
          -d haproxy:2.2.14
      ```
