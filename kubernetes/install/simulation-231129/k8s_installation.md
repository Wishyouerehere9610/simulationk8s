## k8s installation
1. 3 nodes with centos7
    * master: `simulation-01`
    * worker1: `simulation-02`
    * worker2: `simulation-03`
2. configure hosts for all nodes
    * ```shell
      cat >> /etc/hosts <<EOF
      10.101.16.62 simulation-01
      10.101.16.63 simulation-02
      10.101.16.64 simulation-03
      EOF
      ```
3. remove all repo configuration
    * ```shell
      rm -rf /etc/yum.repos.d/*
      ```
    * copy [all.in.one.7.repo](resources/all.in.one.7.repo.md) as file `/etc/yum.repos.d/all.in.one.7.repo`
4. configure ntp
    * ```shell
      yum install -y chrony && systemctl enable chronyd && systemctl start chronyd \
         && chronyc sources && chronyc tracking \
         && timedatectl set-timezone 'Asia/Shanghai'
      ```