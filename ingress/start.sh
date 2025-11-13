kind delete cluster --name app-1-cluster
kind create cluster --name app-1-cluster --config test.yaml --image kindest/node:v1.29.2
# kubectl apply -f deploy-ingress-nginx.yaml
# kubectl -n ingress-nginx get services
kubectl apply -f http-ingress.yaml
kubectl apply -f nginx.yaml
kubectl get pods

# get the loadalancer IP

# LOADBALANCER_IP=$(kubectl get services \
#    --namespace ingress-nginx \
#    ingress-nginx-controller \
#    --output jsonpath='{.status.loadBalancer.ingress[0].ip}')

# # should output "foo-app"

# curl ${LOADBALANCER_IP}/foo

# # should output "bar-app"

# curl ${LOADBALANCER_IP}/bar

# should output "foo-app"

# kubectl port-forward service/foo-service 30001:8080
# kubectl port-forward service/bar-service 30002:8080

curl http://localhost:30001/foo

# should output "bar-app"

curl http://localhost:30002/bar