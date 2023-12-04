
# Using Prometheus for Monitoring on Google Cloud: Qwik Start [GSP1024]

# If you consider that the video helped you to complete your lab, so please do like and subscribe. https://www.youtube.com/@techcps

* In the GCP Console open the Cloud Shell and enter the following commands

```
gcloud auth list
gcloud config list project

gcloud beta container clusters create gmp-cluster --num-nodes=1 --zone us-east4-c --enable-managed-prometheus
gcloud container clusters get-credentials gmp-cluster --zone us-east4-c
kubectl create ns gmp-test

kubectl -n gmp-test apply -f https://raw.githubusercontent.com/kyleabenson/flask_telemetry/master/gmp_prom_setup/flask_deployment.yaml
kubectl -n gmp-test apply -f https://raw.githubusercontent.com/kyleabenson/flask_telemetry/master/gmp_prom_setup/flask_service.yaml
url=$(kubectl get services -n gmp-test -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}')
curl $url/metrics
kubectl -n gmp-test apply -f https://raw.githubusercontent.com/kyleabenson/flask_telemetry/master/gmp_prom_setup/prom_deploy.yaml
timeout 120 bash -c -- 'while true; do curl $(kubectl get services -n gmp-test -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}'); sleep $((RANDOM % 4)) ; done'

gcloud monitoring dashboards create --config='''
{
"category": "CUSTOM",
"displayName": "Prometheus Dashboard Example",
"mosaicLayout": {
"columns": 12,
"tiles": [
{
"height": 4,
"widget": {
"title": "prometheus/flask_http_request_total/counter [MEAN]",
"xyChart": {
"chartOptions": {
"mode": "COLOR"
},
"dataSets": [
{
"minAlignmentPeriod": "60s",
"plotType": "LINE",
"targetAxis": "Y1",
"timeSeriesQuery": {
"apiSource": "DEFAULT_CLOUD",
"timeSeriesFilter": {
"aggregation": {
"alignmentPeriod": "60s",
"crossSeriesReducer": "REDUCE_NONE",
"perSeriesAligner": "ALIGN_RATE"
},
"filter": "metric.type=\"prometheus.googleapis.com/flask_http_request_total/counter\" resource.type=\"prometheus_target\"",
"secondaryAggregation": {
"alignmentPeriod": "60s",
"crossSeriesReducer": "REDUCE_MEAN",
"groupByFields": [
"metric.label.\"status\""
],
"perSeriesAligner": "ALIGN_MEAN"
}
}
}
}
],
"thresholds": [],
"timeshiftDuration": "0s",
"yAxis": {
"label": "y1Axis",
"scale": "LINEAR"
}
}
},
"width": 6,
"xPos": 0,
"yPos": 0
}
]
}
}
'''
```

# Congratulations, you're all done with the lab 😄

# Thanks for watching :)


