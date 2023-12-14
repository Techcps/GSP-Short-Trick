
# Cloud Endpoints: Qwik Start [GSP164]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

* In the GCP Console open the Cloud Shell and enter the following commands:

```
gcloud alpha services api-keys create --display-name="techcps" 
KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=techcps")
export API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")
export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
gsutil mb gs://$PROJECT_ID
```

# Congratulations, you're all done with the lab 😄

# Thanks for watching :)
