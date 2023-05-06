## basic mirrors

### centos mirrors
* centos 7 `/etc/yum.repos.d/conti.all.repo`
    + [CentOS mirror](resources/CentOS_centos_7.repo.md)
    + [Aliyun mirror](resources/aliyun_centos_7.repo.md)
    + [163 mirror](resources/163_centos_7.repo.md)
    + [tuna mirror](resources/tuna_centos_7.repo.md)
* centos 8 stream `/etc/yum.repos.d/conti.all.repo`
    + [CentOS mirror](resources/CentOS_centos_8.repo.md)
    + [Aliyun mirror](resources/aliyun_centos_8.repo.md)
    + [tuna mirror](resources/tuna_centos_8.repo.md)

### ubuntu
* ubuntu 18.04 `/etc/apt/sources.list`
    + [Ubuntu mirror](resources/Ubuntu_ubuntu_18.04.repo.md)
    + [tuna mirror](resources/tuna_ubuntu_18.04.repo.md)
* ubuntu 20.04 `/etc/apt/sources.list`
    + [Ubuntu mirror](resources/Ubuntu_ubuntu_20.04.repo.md)
    + [tuna mirror](resources/tuna_ubuntu_20.04.repo.md)
* ubuntu 22.04 `/etc/apt/sources.list`
    + [Ubuntu mirror](resources/Ubuntu_ubuntu_22.04.repo.md)
    + [tuna mirror](resources/tuna_ubuntu_22.04.repo.md)

### debian
* debian buster `/etc/apt/sources.list`
    + [Debian mirror](resources/Debian_debian_buster.repo.md)
    + [Aliyun mirror](resources/aliyun_debian_buster.repo.md)
    + [tuna mirrot](resources/tuna_debian_buster.repo.md)
* debian bullseye `/etc/apt/sources.list`
    + [Debian mirror](resources/Debian_debian_bullseye.repo.md)
    + [Aliyun mirror](resources/aliyun_debian_bullseye.repo.md)
    + [tuna mirrot](resources/tuna_debian_bullseye.repo.md)

### alpine
* alpine `/etc/apk/repositories`
    + ```shell
      # Aliyun mirror
      sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
      ```
    + ```shell
      # tuna mirror
      sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
      ```
