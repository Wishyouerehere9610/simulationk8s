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
    * prepare local yum-registry [Fedora-38-yum-231009](resources/Fedora-38-yum-231009.md)
    * copy `Fedora-38-base-231009.tar.gz` as file `/data/Fedora-38-base-231009.tar.gz`
    * copy `Fedora-38-updates-231009.tar.gz` as file `/data/Fedora-38-updates-231009.tar.gz`
    * copy `Fedora-38-docker-ce-231009.tar.gz` as file `/data/Fedora-38-docker-ce-231009.tar.gz`
    * remove all repo configuration
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
      dnf install -y vim curl net-tools docker-ce-23.0.6 containerd.io \
           docker-ce-cli-23.0.6 docker-ce-rootless-extras-23.0.6 docker-compose-plugin-2.19.1
      ```
4. prepare images
    * prepare [kubespray-images](resources/kubespray-images.md)
    * copy `kubespray-images.tar.gz` as file `$HOME/kubespray-images.tar.gz`
    * ```shell
      DOCKER_IMAGE_PATH=$HOME/kubespray-images && mkdir -p $DOCKER_IMAGE_PATH
      tar xvf $HOME/kubespray-images.tar.gz -C $HOME && \
      for IMAGE in "docker.io-library-nginx-1.25.2-alpine.dim" \
          "docker.io-library-registry-2.8.1.dim" \
          "quay.io-kubespray-kubespray:v2.23.0.dim"
      do
          docker image load -i $DOCKER_IMAGE_PATH/$IMAGE
      done
      ```
5. prepare file repo
    * prepare [kubespray-nginx](resources/kubespray-nginx.md)
    * copy `kubespray-nginx.tar.gz` as file `$HOME/kubespray-nginx.tar.gz`
    * start nginx-server in docker
    * ```shell
      tar zcvf $HOME/kubespray-nginx.tar.gz -C $HOME \
          && bash $HOME/kubespray-nginx/nginx-file.sh
      ```
6. prepare docker-registry
    * ```shell
      docker run \
          --name registry \
          --restart always \
          -p 5000:5000 \
          -d docker.io/library/registry:2.8.1
      ```
    * registering the images to local registry
    * ```shell
       bash $HOME/kubespray-images/images.sh
       ```
7. clone kubespray with specific version(v2.23.0)
    * prepare kubespray-231009](resources/
    * copy `kubespray-231009.tar.gz` as file `$HOME/kubespray-231009.tar.gz`
    * ```shell
      
      tar xvf $HOME/kubespray-offline-231009.tar.gz -C $HOME
      cd $KUBESPRAY_DIREACTORY
      ```
8. load python dependencies for kubespray
    * ```shell
      VENV_DIRECTORY=$HOME/kubespray/venv \
          && source $VENV_DIRECTORY/bin/activate
      ```



9. generate configurations for kubespray
    * ```shell
      cp -rfp inventory/sample inventory/mycluster
      declare -a IPS=(192.168.12.12 192.168.12.13 192.168.12.14)
      CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
      ```
10. stop and disable firewalld
    * ```shell
      ansible -i inventory/mycluster/hosts.yaml all -m command -a "systemctl stop firewalld"
      ansible -i inventory/mycluster/hosts.yaml all -m command -a "systemctl disable firewalld"
      ```
11. modify `inventory/mycluster/group_vars/all/offline.yml`
    * ```text
      ### Private Container Image Registry
      registry_host: "kubespray-operator:5000"
      files_repo: "http://kubespray-operator:8080"
      ### If using CentOS, RedHat, AlmaLinux or Fedora
      yum_repo: "http://mirrors.tuna.tsinghua.edu.cn"
      ```
12. install kubernetes cluster with ansible
     * ```shell
       ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root reset.yml
       # you may have to retry several times to install kubernetes cluster successfully for the bad network
       ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml
       ```
13. copy configurations for kubectl
     * ```shell
       mkdir ~/.kube \
           && sudo cp /etc/kubernetes/admin.conf ~/.kube/config \
           && sudo chown ben.wangz:ben.wangz ~/.kube/config
       ```