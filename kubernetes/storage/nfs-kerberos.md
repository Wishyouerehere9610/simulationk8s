# k8s-nfs-server

* prepare project
  ```shell
  git clone https://github.com/Austen821/k8s-nfs-server.git && cd ./k8s-nfs-server
  ```
* prepare `export`
* prepare images
  ```shell
  docker build -t conti-nfs-server:0.1.1 .
  ```
  ```shell
  dokcer tag conti-nfs-server:0.1.1 localhost:5000/conti-nfs-server:0.1.1
  docker push localhost:5000/conti-nfs-server:0.1.1
  ```

* install
  * prepart [nfs-server.values.yaml](resources/nfs-server.values.yaml.md)
  * install by helm
    ```shell
    helm install \
        --create-namespace \
        --namespace application \
        my-nfs-server \
        ${PWD}/nfs-server \
        --values ${PWD}/nfs-kerberos.values.yaml \
        --atomic
    ```
