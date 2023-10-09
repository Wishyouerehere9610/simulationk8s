## kubespray-offline-231009

### prepare
1. prepare 6 nodes with `Fedora 38`
    * operator: 192.168.11.129(配置工作节点的免密登录)
    * master: 192.168.11.130
    * worker1: 192.168.11.131
    * worker2: 192.168.11.132
    * worker3: 192.168.11.133
2. resources info
    * basic-env #部署准备工作中需要执行自动化脚本
    * nginx #nginx默认根目录，k8s部署相关的文件
    * registry #私有镜像仓库registry镜像及部署脚本
    * kubespray-v2.23.0.tar.gz #官方kubespray-v2.23.0源码
    * kubespray-venv #解决ansible及python环境问题

### installation operator
1. configure repositories
    * remove all repo configuration
    * copy `Fedora-38-base-231009.tar.gz` as file `/data/Fedora-38-base-231009.tar.gz`
    * copy `Fedora-38-updates-231009.tar.gz` as file `/data/Fedora-38-updates-231009.tar.gz`
    * copy `Fedora-38-docker-ce-231009.tar.gz` as file `/data/Fedora-38-docker-ce-231009.tar.gz`
    * ```shell
      rm -rf /etc/yum.repos.d/* \
          && tar xvf /data/Fedora-38-base-231009.tar.gz -c /data/base \
          && tar xvf /data/Fedora-38-extras-231009.tar.gz -c /data/updates \
          && tar xvf /data/Fedora-38-docker-ce-231009.tar.gz -c /data/docker-ce
      ```
    * copy [fedora.offline.repo](resources/fedora.offline.repo.md) as file `/etc/yum.repos.d/fedora.offline.repo`
2. configure ntp
    * ```shell
      dnf install -y chrony \
         && systemctl enable chronyd \
         && systemctl start chronyd \
         && chronyc sources && chronyc tracking \
         && timedatectl set-timezone 'Asia/Shanghai'
      ```
3. install basic tools
    * ```shell
      dnf install -y vim curl python3.6 python3-pip net-tools containerd.io \
          docker-ce-23.0.6 docker-ce-cli-23.0.6 docker-ce-rootless-extras-23.0.6
      ```
4. clone kubespray with specific version(v2.23.0)
    * copy `kubespray-offline-v2.23.0.tar.gz` as file `$HOME/kubespray-v2.23.0.tar.gz`
    * ```shell
      KUBESPRAY_DIREACTORY=$HOME/kubespray
      tar xvf $HOME/kubespray-v2.23.0.tar.gz -C $KUBESPRAY_DIREACTORY
      cd $KUBESPRAY_DIREACTORY
      ```
5. load python dependencies for kubespray
    * ```shell
      VENV_DIRECTORY=$HOME/kubespray/venv \
          && source $VENV_DIRECTORY/bin/activate
      ```
6. 启动一个nginx服务, 提供file
7. 启动一个registry, 提供images
9. generate configurations for kubespray
    * ```shell
      cp -rfp inventory/sample inventory/mycluster
      declare -a IPS=(192.168.112.131 192.168.112.132 192.168.112.133)
      CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
      # Review and change parameters under ``inventory/mycluster/group_vars``
      #less inventory/mycluster/group_vars/all/all.yml
      #less inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml
      # modify `upstream_dns_servers in `inventory/mycluster/group_vars/all/all.yml`
      # uncomment `upstream_dns_servers` and add `223.5.5.5`, `223.6.6.6` to dns servers
      # https://github.com/kubernetes-sigs/kubespray/issues/9948
      vim inventory/mycluster/group_vars/all/all.yml
      ```
10. install base environment
     * copy [kubespray-setup.sh](resources/kubespray-setup.sh.md) as file `/tmp/kubespray-setup.sh`
     * ```shell
       bash /tmp/kubespray-setup.sh
       ```
13. install kubernetes cluster with ansible
     * ```shell
       ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root reset.yml
       # you may have to retry several times to install kubernetes cluster successfully for the bad network
       ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml
       ```
14. copy configurations for kubectl
     * ```shell
       mkdir ~/.kube \
           && sudo cp /etc/kubernetes/admin.conf ~/.kube/config \
           && sudo chown ben.wangz:ben.wangz ~/.kube/config
       ```