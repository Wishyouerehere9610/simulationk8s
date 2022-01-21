## haproxy

* Prepare the catalog
  * ```shell
    mkdir -p /mnt/data/haproxy && cd /mnt/data/haproxy
    mkdir pem
    ```
* prepare [haproxy.cfg](resources/haproxy.cfg.md)
* docker run haproxy
  * ```shell
    docker run --restart always \
        -p 443:443 \
        -p 80:80 \
        -p 1088:1088 \
        -p 3306:3306 \
        -p 3307:3307 \
        -p 6379:6379 \
        -p 6380:6380 \
        -v /mnt/data/haproxy/pem/:/usr/local/etc/haproxy/certs/ \
        -v /mnt/data/haproxy/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro \
        -d haproxy:2.2.14
    ```