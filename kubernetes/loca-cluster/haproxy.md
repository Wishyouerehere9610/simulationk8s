## haproxy

* Prepare the catalog
    * ```shell
      mkdir -p /data/haproxy && cd /data/haproxy
      mkdir pem
      ```
* prepare [haproxy.cfg](resources/haproxy.cfg.md)
* docker run haproxy
    * ```shell
      docker run --restart always \
          -p 443:443 \
          -p 80:80 \
          -p 1022:1022 \ 
          -p 3306:3306 \
          -p 6379:6379 \
          -v /data/haproxy/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro \
          -d haproxy:2.2.14
      ```
    * ports
        + ingress: 443, 80
        + mysql: 3306
        + redis: 6379
        + gitea-ops-ssh: 1022
