#catsconti.github.io
```yaml
controller:
  image:
    registry: localhost:5000/k8s.gcr.io
    image: ingress-nginx/controller
    tag: "v1.0.3"
    digest: ""
  service:
    type: NodePort
    nodePorts:
      http: 32080
      https: 32443
      tcp:
        3000: 32808
  admissionWebhooks:
    patch:
      image:
        registry: localhost:5000/k8s.gcr.io
        image: ingress-nginx/kube-webhook-certgen
        tag: v1.0
        digest: ""
        pullPolicy: IfNotPresent
defaultBackend:
  enabled: false
  name: defaultbackend
  image:
    registry: k8s.gcr.io
    image: defaultbackend-amd64
    tag: "1.5"
    pullPolicy: IfNotPresent
imagePullSecrets: []

./bin/helm install \
    --create-namespace --namespace defaule \
    gitea-ingress-nginx \
    ingress-nginx \
    --version 4.0.5 \
    --repo https://kubernetes.github.io/ingress-nginx \
    --values $(pwd)/ingress.nginx.values.yaml \
    --atomic
```


