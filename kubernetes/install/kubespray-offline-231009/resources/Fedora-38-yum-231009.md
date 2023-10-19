### make yum-registry in docker
1. start fedora in docker
    * ```shell
      docker run \
          -ti --rm \
          -v /data/fedora:/data \
          fedora:38 bash
      ```
2. remove all repo configuration
    * ```shell
      rm -rf /etc/yum.repos.d/*
      ```
3. copy [fedora.yum.repo](fedora.yum.repo.md) as file `/etc/yum.repos.d/fedora.yum.repo`
    * ```shell
      dnf clean all && dnf makecache \
          && dnf install -y vim curl yum-utils dnf-utils \
          && reposync -p /data --repo=fedora --download-metadata \
          && reposync -p /data --repo=updates --download-metadata \
          && reposync -p /data --repo=docker-ce --download-metadata
      ```
4. Pack as tar.gz
    * ```shell
      tar zcvf Fedora-38-base-231009.tar.gz fedora/ \
          && tar zcvf Fedora-38-updates-231009.tar.gz updates/ \
          && tar zcvf Fedora-38-docker-ce-231009.tar.gz docker-ce
      ```
