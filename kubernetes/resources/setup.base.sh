#! /bin/bash

set -e
set -x
# install docker
dnf install -y device-mapper-persistent-data lvm2 ansible podman python3.6 iproute-tc
if type setenforce > /dev/null 2>&1; then
    selinuxenabled && setenforce 0
    sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
fi
if [ -f "/etc/fstab" ]; then
    sed -i -Ee 's/^([^#].+ swap[ \t].*)/#\1/' /etc/fstab
fi
swapoff -a
sysctl --system
