## deploy
1. ```shell
   for IMAGE in "ghcr.io/devmachine-fr/cert-manager-alidns-webhook/cert-manager-alidns-webhook:0.2.0"
   do
   LOCAL_IMAGE="localhost:5000/$IMAGE"
   docker image inspect $IMAGE || docker pull $IMAGE
   docker image tag $IMAGE $LOCAL_IMAGE
   docker push $LOCAL_IMAGE
    done
   ```

2. 两种方式

    * ```shell
      helm install \
          --create-namespace --namespace application \
          my-cert-manager \
          https://github.com/DEVmachine-fr/cert-manager-alidns-webhook/releases/download/alidns-webhook-0.6.0/alidns-webhook-0.6.0.tgz \
          --values alidns.yaml \
          --atomic
      ```

    * ```shell
      wget https://github.com/DEVmachine-fr/cert-manager-alidns-webhook/releases/download/alidns-webhook-0.6.0/alidns-webhook-0.6.0.tgz
      
      helm install \
          --create-namespace --namespace application \
          my-alidns-webhook ./alidns-webhook \
          --values alidns.yaml \
          --atomic
      ```
      
      * ```yaml
        image:
          repository: localhost:5000/ghcr.io/devmachine-fr/cert-manager-alidns-webhook/cert-manager-alidns-webhook
          tag: 0.2.0
          pullPolicy: IfNotPresent
          privateRegistry:
            enabled: false
            dockerRegistrySecret: alibaba-container-registry
        certManager:
          namespace: application
          serviceAccountName: my-cert-manager
        ```
      
        

3. 两种方式

   * ```yaml
     kubectl delete certificate conti2021 -n application 
     kubectl delete issuer letsencrypt -n application
     
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
   
   * ```shell
     kubectl delete ClusterIssuer letsencrypt 
     kubectl delete ingress my-ingress -n application
     
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
   
   * 假如说需要nginx
     
     * ```yaml
       apiVersion: apps/v1beta1
       kind: Deployment
       metadata:
         name: nginx
         labels:
           component: nginx
       spec:
         replicas: 1
         template:
           metadata:
             labels:
               component: nginx
           spec:
             containers:
             - name: nginx
               image: nginx
               imagePullPolicy: IfNotPresent
               resources:
                 requests:
                   cpu: 0.25
                 limits:
                   cpu: 1
               ports:
               - containerPort: 80
                 name: http
               livenessProbe:
                 tcpSocket:
                   port: http
                 initialDelaySeconds: 20
                 periodSeconds: 10
               readinessProbe:
                 httpGet:
                   path: /
                   port: http
                 initialDelaySeconds: 20
                 timeoutSeconds: 5
       ---
       apiVersion: v1
       kind: Service
       metadata:
         name: nginx
         labels:
           component: nginx
       spec:
         selector:
           component: nginx  
         ports:
         - name: http
           port: 80
           targetPort: 80
       ```
     
       
   

