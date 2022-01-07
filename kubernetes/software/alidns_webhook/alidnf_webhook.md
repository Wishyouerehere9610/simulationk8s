## alidns-webhook

### mainusage
* 用于使用DNS-01的方式申请ssl证书
### conceptions
* none
### purpose
* create a kubernetes cluster by kind
* 通过插件的方式进行ssl证书申请
* 案例中会用阿里云DNS服务进行演示
### precondition
* [kuberneter by kind](/kubernetes/create.local.cluster.with.kind.md)
* [ingress-nginx](/kubernetes/basic/ingress.nginx.md)
* [cert-manage](/kubernetes/basic/cert-manager/cert.manager.md)

### do it
* prepare [alidns-webhook.yaml](alidns_webhook.yaml.md)
* prepare images
  * ```shell
    for IMAGE in \
        "ghcr.io/devmachine-fr/cert-manager-alidns-webhook/cert-manager-alidns-webhook:0.2.0"
    do
        LOCAL_IMAGE="localhost:5000/$IMAGE"
        docker image inspect $IMAGE || docker pull $IMAGE
        docker image tag $IMAGE $LOCAL_IMAGE
        docker push $LOCAL_IMAGE
    done
    ```
* install
   * ```shell
     helm install \
     --create-namespace --namespace application \
     my-alidns-webhook \
     https://github.com/DEVmachine-fr/cert-manager-alidns-webhook/releases/download/alidns-webhook-0.6.0/alidns-webhook-0.6.0.tgz \
     --values alidns.yaml \
     --atomic
     ```
* 申请证书的两种方式
  * Certificate方式
    * ```shell
      cat << EOF | kubectl apply -f -
      apiVersion: cert-manager.io/v1
      kind: Issuer
      metadata:
        name: letsencrypt
        namespace: application
      spec:
        acme:
          email: conti821@163.com
          privateKeySecretRef:
            name: letsencrypt
          server: https://acme-v02.api.letsencrypt.org/directory
          solvers:
          - dns01:
              webhook:
                config:
                  accessTokenSecretRef:
                    key: access-token
                    name: alidns-secrets
                  regionId: cn-beijing
                  secretKeySecretRef:
                    key: secret-key
                    name: alidns-secrets
                groupName: certmanager.webhook.alidns
                solverName: alidns-solver
            selector:
              dnsNames:
              - "*.conti2021.icu"
      ---
      apiVersion: cert-manager.io/v1
      kind: Certificate
      metadata:
        name: conti2021
        namespace: application
      spec:
        secretName: conti2021-tls
        commonName: conti2021.icu
        dnsNames:
        - conti2021.icu
        - "*.conti2021.icu"
        issuerRef:
          name: letsencrypt
          kind: Issuer
       EOF
       ```
  * 通过ingress申请
    * ```shell
       cat <<EOF | kubectl apply -f - 
       apiVersion: cert-manager.io/v1
       kind: ClusterIssuer
       metadata:
         name: letsencrypt
         namespace: application
       spec:
         acme:
           server: https://acme-staging-v02.api.letsencrypt.org/directory
           email: conti821@163.com
           privateKeySecretRef:
             name: letsencrypt
           solvers:
           - dns01:
               webhook:
                   config:
                     accessTokenSecretRef:
                       key: access-token
                       name: alidns-secrets
                     regionId: cn-beijing
                     secretKeySecretRef:
                       key: secret-key
                       name: alidns-secrets
                   groupName: certmanager.webhook.alidns
                   solverName: alidns-solver
       ---
       apiVersion: networking.k8s.io/v1
       kind: Ingress
       metadata:
         name: my-ingress
         namespace: application
         annotations:
           kubernetes.io/ingress.class: nginx
           certmanager.k8s.io/cluster-issuer: "letsencrypt"
           nginx.ingress.kubernetes.io/rewrite-target: /$1
           nginx.ingress.kubernetes.io/proxy-body-size: 10g
       spec:
         tls:
         - hosts:
           - '*.conti2021.icu'
           secretName: conti2021-tls
         rules:
         - host: www.conti2021.icu
           http:
             paths:
             - path: /
               backend:
                 serviceName: my-nginx
                 servicePort: 80
       EOF
       ```
     
       
   

