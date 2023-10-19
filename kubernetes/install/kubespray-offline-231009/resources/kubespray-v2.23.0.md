### make kubespray-v2.23.0
1. clone kubespray with specific version(v2.23.0)
    * ```shell
      KUBESPRAY_DIREACTORY=$HOME/kubespray
      git clone -b v2.23.0 https://github.com/kubernetes-sigs/kubespray $KUBESPRAY_DIREACTORY
      cd $HOME && tar zcvf kubespray-v2.23.0.tar.gz kubespray/
      ```
