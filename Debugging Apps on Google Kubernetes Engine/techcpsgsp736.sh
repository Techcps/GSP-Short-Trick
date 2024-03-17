
export REGION=${ZONE%-*}
gcloud config set compute/zone $ZONE
gcloud config set compute/region $REGION

export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud container clusters list

gcloud container clusters get-credentials central --zone $ZONE

sleep 10

kubectl get nodes

git clone https://github.com/xiangshen-dk/microservices-demo.git

cd microservices-demo

kubectl apply -f release/kubernetes-manifests.yaml

sleep 25

kubectl get pods

export EXTERNAL_IP=$(kubectl get service frontend-external | awk 'BEGIN { cnt=0; } { cnt+=1; if (cnt > 1) print $4; }')

curl -o /dev/null -s -w "%{http_code}\n"  http://$EXTERNAL_IP

gcloud logging metrics create Error_Rate_SLI --description="please subscribe to techcps" --log-filter='resource.type="k8s_container" severity=ERROR labels."k8s-pod/app": "recommendationservice"'

cat > cp.json <<EOF_END
{
  "displayName": "Error Rate SLI",
  "userLabels": {},
  "conditions": [
    {
      "displayName": "Kubernetes Container - logging/user/Error_Rate_SLI",
      "conditionThreshold": {
        "filter": "resource.type = \"k8s_container\" AND metric.type = \"logging.googleapis.com/user/Error_Rate_SLI\"",
        "aggregations": [
          {
            "alignmentPeriod": "600s",
            "crossSeriesReducer": "REDUCE_NONE",
            "perSeriesAligner": "ALIGN_RATE"
          }
        ],
        "comparison": "COMPARISON_GT",
        "duration": "60s",
        "trigger": {
          "count": 1
        },
        "thresholdValue": 0.5
      }
    }
  ],
  "alertStrategy": {
    "autoClose": "604800s"
  },
  "combiner": "OR",
  "enabled": true,
  "notificationChannels": [],
  "severity": "SEVERITY_UNSPECIFIED"
}
EOF_END

gcloud alpha monitoring policies create --policy-from-file="cp.json"
