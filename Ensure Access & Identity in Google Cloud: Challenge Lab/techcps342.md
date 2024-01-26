
# Ensure Access & Identity in Google Cloud: Challenge Lab [GSP342]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

* In the GCP Console active your Cloud Shell and run the following commands:

```
export CUSTOM_SECURIY_ROLE=
```
```
export SERVICE_ACCOUNT=
```
```
export CLUSTER_NAME=
```
```
export ZONE=
```
```
curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Ensure%20Access%20%26%20Identity%20in%20Google%20Cloud%3A%20Challenge%20Lab/Techcpsgsp342.sh
sudo chmod +x Techcpsgsp342.sh
./Techcpsgsp342.sh
```

## It will take around 7 to 8 minutes to completed, Just wait 

# NOTE: Go to Compute Engine > Click SSH on orca-jumphost instance

```
export ZONE=
```
```
export CLUSTER_NAME=
```
```
export PROJECT_ID=
```
```
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
echo "export USE_GKE_GCLOUD_AUTH_PLUGIN=True" >> ~/.bashrc
source ~/.bashrc
gcloud container clusters get-credentials $CLUSTER_NAME --internal-ip --project $PROJECT_ID --zone $ZONE
kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0
kubectl expose deployment hello-server --name orca-hello-service --type LoadBalancer --port 80 --target-port 8080
```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
