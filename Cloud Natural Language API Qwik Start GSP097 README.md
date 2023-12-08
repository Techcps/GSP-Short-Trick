
# Cloud Natural Language API: Qwik Start [GSP097]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

* In the GCP Console open the Cloud Shell and enter the following commands:

```
gcloud auth list
gcloud config list project
export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value core/project)
gcloud iam service-accounts create my-natlang-sa \
--display-name "my natural language service account"
gcloud iam service-accounts keys create ~/key.json \
--iam-account my-natlang-sa@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com
gcloud compute ssh linux-instance
```
## Note: 
* Press Y then Enter
* Press two times Enter keys back-to-back times
* Press N then Enter

```
gcloud ml language analyze-entities --content="Michelangelo Caravaggio, Italian painter, is known for 'The Calling of Saint Matthew'." > result.json
```

# Congratulations, you're all done with the lab 😄

# Thanks for watching :)
