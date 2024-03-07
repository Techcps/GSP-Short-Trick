
# Configuring IAM Permissions with gcloud [GSP647]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps) & join our [WhatsApp Channel](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)

```
export ZONE=
```
```
gcloud compute ssh centos-clean --zone=$ZONE --quiet
```
```
gcloud compute instances create lab-1 --zone=$ZONE --machine-type=e2-standard-2
```
## Change your current zone for another zone in the same region
>  For example, if your current zone is us-central1-a, you could select us-central1-b or "c" or "d"

```
gcloud config set compute/zone $ZONE
```
```
gcloud init --no-launch-browser
```

> Set USERNAME 2
```
export USER2=
```
> Set PROJECT ID 2 
```
export PROJECT_ID2=
```
```
curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Configuring%20IAM%20Permissions%20with%20gcloud/techcps.sh
sudo chmod +x techcps.sh
./techcps.sh
```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
