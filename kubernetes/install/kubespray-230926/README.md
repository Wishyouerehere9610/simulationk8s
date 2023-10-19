## kubernetes_230926

### prepare
1. prepare 3 nodes with `Fedora 38`
    * master: 192.168.11.139(配置工作节点的免密登录)
    * worker1: 192.168.11.140
    * worker2: 192.168.11.141

### installation
1. reference: [kubespray](https://github.com/kubernetes-sigs/kubespray)
2. configure repositories
    * remove all repo configuration
    * ```shell
      rm -rf /etc/yum.repos.d/*
      ```
    * copy [fedora.aliyun.repo](resources/fedora.aliyun.repo.md) as file `/etc/yum.repos.d/fedora.aliyun.repo`
3. configure ntp
    * ```shell
      dnf install -y chrony \
         && systemctl enable chronyd \
         && systemctl start chronyd \
         && chronyc sources && chronyc tracking \
         && timedatectl set-timezone 'Asia/Shanghai'
      ```
4. install basic tools
    * ```shell
      dnf install -y git vim curl wget python3 python3-pip net-tools
      ```
5. clone kubespray with specific version(v2.23.0)
    * ```shell
      KUBESPRAY_DIREACTORY=$HOME/kubespray
      git clone -b v2.23.0 https://github.com/kubernetes-sigs/kubespray $KUBESPRAY_DIREACTORY
      cd $KUBESPRAY_DIREACTORY && pip install -U -r requirements.txt      
      ```
6. generate configurations for kubespray
    * ```shell
      cp -rfp inventory/sample inventory/mycluster
      declare -a IPS=(192.168.11.139 192.168.11.140 192.168.11.141)
      CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
      ```
7. stop and disable firewalld
    * ```shell
      ansible -i inventory/mycluster/hosts.yaml all -m command -a "systemctl stop firewalld"
      ansible -i inventory/mycluster/hosts.yaml all -m command -a "systemctl disable firewalld"
      ```
8. prepare config
    * ```shell
      # Review and change parameters under ``inventory/mycluster/group_vars``
      #less inventory/mycluster/group_vars/all/all.yml
      #less inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml
      # modify `upstream_dns_servers in `inventory/mycluster/group_vars/all/all.yml`
      # uncomment `upstream_dns_servers` and add `223.5.5.5`, `223.6.6.6` to dns servers
      # https://github.com/kubernetes-sigs/kubespray/issues/9948
      # vim inventory/mycluster/group_vars/all/all.yml
      ```
9. install kubernetes cluster with ansible
    * ```shell
      ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml
      ```
10. copy configurations for kubectl
    * ```shell
      mkdir ~/.kube \
          && cp /etc/kubernetes/admin.conf ~/.kube/config \
          && chown $(id -u):$(id -g) $HOME/.kube/config
      ```