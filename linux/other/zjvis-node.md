## zjvis-node

### network bond0
1. modify `/etc/sysconfig/network-scripts/ifcfg-eno1`
    * ```text
      TYPE=Ethernet
      BOOTPROTO=none
      USERCTL=no
      MASTER=bond0
      SLAVE=yes
      DEVICE=eno1
      ONBOOT=yes
      ```
2. modify `/etc/sysconfig/network-scripts/ifcfg-eno2`
    * ```text
      TYPE=Ethernet
      BOOTPROTO=none
      USERCTL=no
      MASTER=bond0
      SLAVE=yes
      DEVICE=eno2
      ONBOOT=yes
      ```
3. touch file `/etc/sysconfig/network-scripts/ifcfg-bond0`
    * ```text
      DEVICE=bond0
      ONBOOT=yes
      IPADDR=10.105.20.26
      BOOTPROTO=none
      NETMASK=255.255.255.0
      GATEWAY=10.105.20.254
      DNS1=10.255.9.2
      TYPE=bond
      USERCTL=no
      ```
4. restart network `bond0` `eno1` `eno2`
    * ```shell
      ifup bond0
      ifdown eno1 eno2 
      ifup eno1 eno2 
      ```

### disk plan
1. create LV `docker`
    * ```shell
      echo "/dev/mapper/centos-docker /var/lib/docker xfs defaults 0 0" >> /etc/fstab
      lvcreate -L 500G -n docker centos
      mkfs.xfs /dev/mapper/centos-docker
      mkdir /var/lib/docker && chmod 755 /var/lib/docker && mount -a
      ```
2. create LV `data`
    * ```shell
      echo "/dev/mapper/centos-data /data xfs defaults 0 0" >> /etc/fstab
      lvcreate -L 2.7T -n data centos
      mkfs.xfs /dev/mapper/centos-data
      mkdir /data && mount -a
      ```
3. mount `nasdisk`
    * ```shell
      echo "oss-std-lc128.alkaidos.cn:/csst/csst /nasdisk nfs vers=3,nolock 0 0" >> /etc/fstab
      mkdir /nasdisk && mount -a
      ```

### installation
1. configure repositories
    * ```shell
      rm -rf /etc/yum.repos.d/*
      ```
    * copy [all.in.one.7.repo](resources/all.in.one.7.repo.md) as file `/etc/yum.repos.d/all.in.one.7.repo`
2. configure ntp
    * ```shell
      yum install -y chrony && systemctl enable chronyd && systemctl start chronyd \
         && chronyc sources && chronyc tracking \
         && timedatectl set-timezone 'Asia/Shanghai'
      ```
3. install basic module
    * ```shell
      yum install -y vim net-tools device-mapper-persistent-data lvm2 docker-ce python3 iproute-tc \
          && systemctl start docker && systemctl enable docker
      ```
4. stop and disable firewalld
    * ```shell
      systemctl stop firewalld && systemctl disable firewalld
      ```










