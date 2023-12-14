
# Cloud Endpoints: Qwik Start [GSP164]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

* In the GCP Console open the Cloud Shell and enter the following commands:

```
gcloud auth list
gcloud config list project
gsutil cp gs://spls/gsp164/endpoints-quickstart.zip .
unzip endpoints-quickstart.zip
cd endpoints-quickstart/scripts

./deploy_api.sh

./deploy_app.sh

./query_api.sh

./query_api.sh JFK

./deploy_api.sh ../openapi_with_ratelimit.yaml

./deploy_app.sh

gcloud alpha services api-keys create --display-name="techcps"
KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=techcps")
export API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")
./query_api_with_key.sh $API_KEY
./generate_traffic_with_key.sh $API_KEY
./query_api_with_key.sh $API_KEY
```

# Congratulations, you're all done with the lab 😄

# Thanks for watching :)
