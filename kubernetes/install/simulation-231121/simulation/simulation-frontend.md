## simulation-frontend

### installation
1. prepare business image
    * `dokcer.io/cnconti/simulation-frontend:5fd3ba7d9f` # [Dockerfile](resources/simulation-frontend.business.md)
    * ```shell
      kind load docker-image dokcer.io/cnconti/simulation-frontend:5fd3ba7d9f
      ```
2. prepare helm values 
    * prepare [simulation-frontend.values.yaml](resources/simulation-frontend.values.yaml.md)
3. install `simulation-frontend` by helm
    * ```shell
      helm install \
          --create-namespace --namespace simulation \
          simulation-frontend \
          nginx \
          --repo https://chartmuseum-ops-dev.lab.zjvis.net:32443 \
          --version 1.0.0-C12b9740 \
          --values simulation.frontend.values.yaml \
          --atomic
      ```
4. upgrade `simulation-frontend` by helm
    * ```shell
      helm upgrade --namespace simulation \
          simulation-frontend \
          nginx \
          --repo https://chartmuseum-ops-dev.lab.zjvis.net:32443 \
          --version 1.0.0-C12b9740 \
          --values simulation.frontend.values.yaml \
          --atomic
      ```
    
### uninstall
1. uninstall `simulation-frontend`
    * ```shell
      helm -n simulation uninstall simulation-frontend
      ```