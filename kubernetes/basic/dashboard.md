# kubernetes dashboard

## main usage

* a web based dashboard to manage kubernetes cluster

## conceptions

* none

## pre-requirements

* [download kubernetes binary tools](../download.kubernetes.binary.tools.md)
* [create local cluster for testing](local.cluster.for.testing.md)
* [ingress-nginx](ingress.nginx.md)
* [cert-manager](cert.manager.md)

## purpose

* create a kubernetes cluster by kind
* setup kubernetes dashboard
* create a read only user

## do it

1. combination of issuer and `issuerself-signed` `CA`
   * prepare [self.signed.issuer.yaml](dashboard/self.signed.issuer.yaml.md)
   * ```shell
     kubectl get namespace dashboard > /dev/null 2>&1 || kubectl create namespace dashboard
     kubectl -n test apply -f self.signed.issuer.yaml
     ```
2. prepart [dashboard.values.yaml](dashboard/dashboard.values.yaml.md)
3. prepare images
   * ```shell  
     for IMAGE in "kubernetesui/dashboard:v2.4.0"
     do
         LOCAL_IMAGE="localhost:5000/$IMAGE"
         docker image inspect $IMAGE || docker pull $IMAGE
         docker image tag $IMAGE $LOCAL_IMAGE
         docker push $LOCAL_IMAGE
     done
     ```
3. install by helm
   * ```shell
     helm install \
         --create-namespace --namespace dashboard \
         my-dashboard \
         kubernetes-dashboard \
         --repo https://kubernetes.github.io/dashboard \
         --values dashboard.values.yaml \
         --version 5.0.5 \
         --atomic
     ```

## test
1. 查看certificate状态
   * certificate true?
     ```shell
     kubectl -n dashboard get certificate 
     ```
2. 修改hosys文件
   * hosts文件
     ```text
     修改本机hosts文件
     ```
3. 拿到sa的token信息作为dashboard的登录信息
   * token信息
     ```shell
     SECRETNAME=$(kubectl -n dashboard get sa/dashboard -o jsonpath="{.secrets[0].name}")
     kubectl -n dashboard get secret ${SECRETNAME} -o jsonpath={.data.token} | base64 -d
     ```
   * GO [https://dashboard.kube.conti.icu](https://dashboard.kube.conti.icu)
  


















