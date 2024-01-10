
# Deploying Google Kubernetes Engine

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

```
export ZONE=
```
```
gcloud auth list
gcloud config list project
gcloud container clusters create standard-cluster-1 --zone=$ZONE --num-nodes=3
gcloud container clusters resize standard-cluster-1 --zone=$ZONE --num-nodes=4
```
## NOTE: Kubernetes Engine > Workloads. Click Create Deployment
* Click Continue > Continue> Deploy

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
