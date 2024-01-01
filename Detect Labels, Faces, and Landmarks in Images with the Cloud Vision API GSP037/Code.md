
# Cloud Endpoints: Qwik Start [GSP037]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

* In the GCP Console open the Cloud Shell and enter the following commands:

```
gcloud alpha services api-keys create --display-name="techcps" 
KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=techcps")
export API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")
export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
gsutil mb gs://$PROJECT_ID
```

# Note: Go to Bucket and upload all three images then run the following commands

```
gcloud storage objects update gs://$PROJECT_ID/donuts.png --add-acl-grant=entity=AllUsers,role=READER
gcloud storage objects update gs://$PROJECT_ID/selfie.png --add-acl-grant=entity=AllUsers,role=READER
gcloud storage objects update gs://$PROJECT_ID/city.png --add-acl-grant=entity=AllUsers,role=READER
```

# Congratulations, you're all done with the lab 😄

# Thanks for watching :)
