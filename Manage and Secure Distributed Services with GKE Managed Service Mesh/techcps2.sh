
gcloud container clusters get-credentials cluster1 --zone=$ZONE --project=$DEVSHELL_PROJECT_ID
gcloud container clusters get-credentials cluster2 --zone=$ZONE --project=$DEVSHELL_PROJECT_ID

kubectl config get-contexts

kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster1 create namespace asm-ingress
kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster1 label namespace asm-ingress istio-injection=enabled --overwrite

kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster2 create namespace asm-ingress
kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster2 label namespace asm-ingress istio-injection=enabled --overwrite




cat <<'EOF' > asm-ingress.yaml
apiVersion: v1
kind: Service
metadata:
  name: asm-ingressgateway
  namespace: asm-ingress
spec:
  type: LoadBalancer
  selector:
    asm: ingressgateway
  ports:
  - port: 80
    name: http
  - port: 443
    name: https
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: asm-ingressgateway
  namespace: asm-ingress
spec:
  selector:
    matchLabels:
      asm: ingressgateway
  template:
    metadata:
      annotations:
        # This is required to tell GKE Service Mesh to inject the gateway with the
        # required configuration.
        inject.istio.io/templates: gateway
      labels:
        asm: ingressgateway
    spec:
      containers:
      - name: istio-proxy
        image: auto # The image will automatically update each time the pod starts.
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: asm-ingressgateway-sds
  namespace: asm-ingress
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "watch", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: asm-ingressgateway-sds
  namespace: asm-ingress
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: asm-ingressgateway-sds
subjects:
- kind: ServiceAccount
  name: default
EOF



kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster1 apply -f asm-ingress.yaml
kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster2 apply -f asm-ingress.yaml


kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster1 get pod,service -n asm-ingress
kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster2 get pod,service -n asm-ingress

sleep 120

kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster1 get pod,service -n asm-ingress
kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster2 get pod,service -n asm-ingress

## Task 4

git clone https://github.com/GoogleCloudPlatform/bank-of-anthos.git ${HOME}/bank-of-anthos

kubectl create --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster1 namespace bank-of-anthos
kubectl label --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster1 namespace bank-of-anthos istio-injection=enabled

kubectl create --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster2 namespace bank-of-anthos
kubectl label --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster2 namespace bank-of-anthos istio-injection=enabled

kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster1 -n bank-of-anthos apply -f ${HOME}/bank-of-anthos/extras/jwt/jwt-secret.yaml
kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster2 -n bank-of-anthos apply -f ${HOME}/bank-of-anthos/extras/jwt/jwt-secret.yaml

kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster1 -n bank-of-anthos apply -f ${HOME}/bank-of-anthos/kubernetes-manifests
kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster2 -n bank-of-anthos apply -f ${HOME}/bank-of-anthos/kubernetes-manifests

kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster2 -n bank-of-anthos delete statefulset accounts-db
kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster2 -n bank-of-anthos delete statefulset ledger-db

kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster1 -n bank-of-anthos get pod


kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster2 -n bank-of-anthos get pod


sleep 120


kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster1 -n bank-of-anthos get pod


kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster2 -n bank-of-anthos get pod


cat <<'EOF' > asm-vs-gateway.yaml
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: asm-ingressgateway
  namespace: asm-ingress
spec:
  selector:
    asm: ingressgateway
  servers:
    - port:
        number: 80
        name: http
        protocol: HTTP
      hosts:
        - "*"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: frontend
  namespace: bank-of-anthos
spec:
  hosts:
  - "*"
  gateways:
  - asm-ingress/asm-ingressgateway
  http:
  - route:
    - destination:
        host: frontend
        port:
          number: 80
EOF

kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster1 apply -f asm-vs-gateway.yaml

kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster2 apply -f asm-vs-gateway.yaml

kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster1 \
--namespace=asm-ingress get svc asm-ingressgateway -o jsonpath='{.status.loadBalancer}' | grep "ingress"


kubectl --context=gke_${DEVSHELL_PROJECT_ID}_${ZONE}_cluster2 \
--namespace=asm-ingress get svc asm-ingressgateway -o jsonpath='{.status.loadBalancer}' | grep "ingress"
