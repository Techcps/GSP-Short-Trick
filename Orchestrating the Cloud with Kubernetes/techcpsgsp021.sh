
gcloud auth list
gcloud config list project

gcloud config set compute/zone $ZONE

gcloud container clusters create io

gsutil cp -r gs://spls/gsp021/* .
cd orchestrate-with-kubernetes/kubernetes

kubectl create deployment nginx --image=nginx:1.10.0

kubectl get pods

kubectl expose deployment nginx --port 80 --type LoadBalancer

kubectl get services

cd ~/orchestrate-with-kubernetes/kubernetes
kubectl create -f pods/monolith.yaml

kubectl get pods

cd ~/orchestrate-with-kubernetes/kubernetes
cat pods/secure-monolith.yaml

kubectl create secret generic tls-certs --from-file tls/

kubectl create configmap nginx-proxy-conf --from-file nginx/proxy.conf

kubectl create -f pods/secure-monolith.yaml

kubectl create -f services/monolith.yaml

gcloud compute firewall-rules create allow-monolith-nodeport --allow=tcp:31000

kubectl get pods -l "app=monolith"

kubectl get pods -l "app=monolith,secure=enabled"

kubectl label pods secure-monolith 'secure=enabled'

kubectl get pods secure-monolith --show-labels

kubectl describe services monolith | grep Endpoints

kubectl create -f deployments/auth.yaml

kubectl create -f services/auth.yaml

kubectl create -f deployments/hello.yaml

kubectl create -f services/hello.yaml

kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf

kubectl create -f deployments/frontend.yaml

kubectl create -f services/frontend.yaml

kubectl get services frontend
