
# Cloud Natural Language API: Qwik Start [GSP097]

# Task 1. Create an API key

```
gcloud auth list
gcloud config list project
export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value core/project)
gcloud iam service-accounts create my-natlang-sa \
  --display-name "my natural language service account"
gcloud iam service-accounts keys create ~/key.json \
  --iam-account my-natlang-sa@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com
export GOOGLE_APPLICATION_CREDENTIALS="/home/USER/key.json"
gcloud compute ssh --zone "us-central1-a" "linux-instance" --project "$GOOGLE_CLOUD_PROJECT"

```

# Task 2. Make an entity analysis request

```
gcloud ml language analyze-entities --content="Michelangelo Caravaggio, Italian painter, is known for 'The Calling of Saint Matthew'." > result.json
```


## Congratulations, you're all done with the lab 😄
## If you consider that the video helped you to complete your lab, so please do like and subscribe
## Thanks for watching :)




