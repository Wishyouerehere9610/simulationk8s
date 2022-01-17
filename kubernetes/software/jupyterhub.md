# jupyterhub

## main usage

- jupyterhub

## conceptions

- none

## purpose

- prepare a kind cluster with basic components
- install `jupyterhub`

## [installation]

1. [prepare a kind cluster with basic components](https://blog.geekcity.tech/#/kubernetes/basic/kind.cluster)

2. download and load images to qemu machine(run command at the host of qemu machine)

3. configure self-signed issuer
   - `self-signed`issuer
     - prepare [self.signed.and.ca.issuer.yaml](https://blog.geekcity.tech/#/kubernetes/basic/resources/cert.manager/self.signed.and.ca.issuer.yaml)
     - ```shell
       kubectl get namespace application > /dev/null 2>&1 || kubectl create namespace application \
       && kubectl -n application apply -f self.signed.and.ca.issuer.yaml
       ```

4. install jupyterhub

   - prepare [jupyterhub.values.yaml](https://blog.geekcity.tech/#/kubernetes/software/resources/jupyterhub/jupyterhub.values.yaml)

   - prepare images

     - run scripts in [load.image.function.sh](https://blog.geekcity.tech/#/kubernetes/resources/load.image.function.sh) to load function `load_image`

     - ```shell
       load_image "docker.registry.local:443" \
           "docker.io/bitnami/jupyterhub:1.5.0-debian-10-r34" \
           "docker.io/bitnami/configurable-http-proxy:4.5.0-debian-10-r146" \
           "docker.io/bitnami/jupyter-base-notebook:1.5.0-debian-10-r34" \
           "docker.io/bitnami/bitnami-shell:10-debian-10-r281" \
           "docker.io/bitnami/postgresql:11.14.0-debian-10-r17" \
           "docker.io/bitnami/bitnami-shell:10-debian-10-r265" \
           "docker.io/bitnami/postgres-exporter:0.10.0-debian-10-r133"
       ```

   - install by helm

     - ```shell
       helm install \
           --create-namespace --namespace application \
           my-jupyterhub \
           https://resource.geekcity.tech/kubernetes/charts/https/charts.bitnami.com/bitnami/jupyterhub-0.3.4.tgz \
           --values jupyterhub.values.yaml \
           --atomic
       ```

## [test](https://blog.geekcity.tech/#/kubernetes/software/jupyterhub?id=test)

1. check connection

   - ```shell
     curl --insecure --header 'Host: jupyterhub.local' https://localhost
     ```

2. visit gitea via website

   - configure hosts

     - ```shell
       echo $QEMU_HOST_IP jupyterhub.local >> /etc/hosts
       ```

   - visit `https://jupyterhub.local:10443/` with your browser

   - login with

     - default user: admin

     - password extracted by command

       - ```shell
         kubectl get secret --namespace application my-jupyterhub-hub -o jsonpath="{.data['values\.yaml']}" | base64 --decode | awk -F: '/password/ {gsub(/[ \t]+/, "", $2);print $2}'
         ```

## [uninstallation](https://blog.geekcity.tech/#/kubernetes/software/jupyterhub?id=uninstallation)

1. uninstall

    

   ```
   jupyterhub
   ```

   - ```shell
     helm -n application uninstall my-jupyterhub \
         && kubectl -n application delete pvc data-my-jupyterhub-postgresql-0 \
         && kubectl -n application delete pvc my-jupyterhub-claim-admin
     ```