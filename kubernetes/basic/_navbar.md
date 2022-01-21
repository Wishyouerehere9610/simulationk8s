- Language / 语言
  - [English](/)


POD_NAME=$(kubectl get pod -n middleware-nebula-dev \
-l "app.kubernetes.io/name=redis-cluster-tool" \
-o jsonpath="{.items[0].metadata.name}") \
&& kubectl -n middleware exec -it $POD_NAME -- bash -c '\
echo "ping" | redis-cli -c -h my-redis-cluster.middleware -a $REDIS_PASSWORD' \
&& kubectl -n middleware exec -it $POD_NAME -- bash -c '\
echo "set mykey somevalue" | redis-cli -c -h my-redis-cluster.middleware -a $REDIS_PASSWORD' \
&& kubectl -n middleware exec -it $POD_NAME -- bash -c '\
echo "get mykey" | redis-cli -c -h my-redis-cluster.middleware -a $REDIS_PASSWORD' \
&& kubectl -n middleware exec -it $POD_NAME -- bash -c '\
echo "del mykey" | redis-cli -c -h my-redis-cluster.middleware -a $REDIS_PASSWORD' \
&& kubectl -n middleware exec -it $POD_NAME -- bash -c '\
echo "get mykey" | redis-cli -c -h my-redis-cluster.middleware -a $REDIS_PASSWORD'