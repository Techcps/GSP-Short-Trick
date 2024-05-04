
# Configuring IAM Permissions with gCloud - AWS [GSP1126
]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps) & join our [WhatsApp Channel](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)


```
export ZONE=
```

```
gcloud compute ssh centos-clean --zone=$ZONE --project=$DEVSHELL_PROJECT_ID --quiet
```

```
gcloud --version

gcloud auth login --quiet
```

```
export REGION="${ZONE%-*}"

gcloud config set compute/region "$REGION"
gcloud config set compute/zone "$ZONE"

gcloud compute instances create lab-1
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
curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Configuring%20IAM%20Permissions%20with%20gcloud%20-%20AWS/techcps.sh
sudo chmod +x techcps.sh
./techcps.sh
```


## Congratulations, you're all done with the lab 😄

# Thanks for watching :)

