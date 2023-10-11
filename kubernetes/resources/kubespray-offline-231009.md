## kubespray-offline

### make yum-registry in docker
1. start fedora in docker
    * ```shell
      docker run \
          -ti --rm \
          -v /data:/data \
          python:3.9.14-bullseye \
          bash
      ```
2. install basic tools
    * ```shell
      sed -i -E 's/(deb|security).debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
          && apt update && apt install -y git
      ```
3. clone kubespray with specific version(v2.23.0)
    * ```shell
      KUBESPRAY_DIREACTORY=$HOME/kubespray
      git clone -b v2.23.0 https://github.com/kubernetes-sigs/kubespray $KUBESPRAY_DIREACTORY
      VENV_DIRECTORY=$HOME/kubespray/venv
      python3 -m venv $VENV_DIRECTORY && source $VENV_DIRECTORY/bin/activate
      pip install --upgrade pip -i https://mirrors.aliyun.com/pypi/simple/ \
          && pip install -U -r $KUBESPRAY_DIREACTORY/requirements.txt -i https://mirrors.aliyun.com/pypi/simple/
      ```
4. Pack as tar.gz
    * ```shell
      cd $HOME && tar zcvf kubespray-offline-v2.23.0.tar.gz kubespray/
      ```
