# haproxy-pem

## installation
1. prepare certificate directory 
    * ```shell
      mkdir -p ${PWD}/haproxy/pem
      ```
2. prepare [haproxy.cfg](resources/haproxy.cfg.md) as file `${PWD}/haproxy/haproxy.cfg`
3. dokcer run `haproxy`
    * ```shell
      docker run --rm \
          -p 443:443 \
          -p 80:80 \
          -restart always \
          -v ${PWD}/haproxy/pem/:/usr/local/etc/haproxy/certs/:ro
          -v ${PWD}/haproxy/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro \
          -d haproxy:2.2.14
      ```
