## kubernetes binary tools

### kind
* ```shell
  BASE_URL=https://github.com/kubernetes-sigs/kind/releases/download
  # BASE_URL=https://resource.cnconti.cc/kubernetes_binary/kind
  
  ## 0.17.0 / 0.16.0 / 0.15.0 / 0.14.0
  KIND_VERSION="v0.17.0" 
  # 0.16.0  # 0.15.0 # 0.14.0
  
  ## amd64 / arm64
  KIND_TYPE="amd64"  
  
  curl -LO ${BASE_URL}/${KIND_VERSION}/kind-linux-${KIND_TYPE}
  ```

### kubectl
* ```shell
  BASE_URL=https://dl.k8s.io/release
  # BASE_URL=https://resource.cnconti.cc/kubernetes_binary/kubectl
  
  ## Select according to demand
  KUBECTL_VERSION="v1.25.3"
  
  ## amd64 / arm64
  KUBECTL_TYPE="amd64"
   
  curl -LO ${BASE_URL}/${KUBECTL_VERSION}/bin/linux/${KUBECTL_TYPE}/kubectl
  ```

### helm
* ```shell
  BASE_URL=https://get.helm.sh
  # BASE_URL=https://resource.cnconti.cc/kubernetes_binary/helm
  
  ## 3.10.3 / 3.9.4
  HELM_VERSION="3.10.3"
  
  ## amd64 / arm64
  HELM_TYPE="amd64"
  
  curl -LO ${BASE_URL}/helm-v${HELM_VERSION}-linux-${HELM_TYPE}.tar.gz \
      && tar -zxvf helm-v${HELM_VERSION}-linux-${HELM_TYPE}.tar.gz \
      && mv linux-${HELM_TYPE}/helm helm && chmod 744 helm\
      && rm -rf linux-amd64/ helm-v${HELM_VERSION}-linux-${HELM_TYPE}.tar.gz
  ```
