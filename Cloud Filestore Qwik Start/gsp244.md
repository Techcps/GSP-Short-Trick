
# Cloud Filestore: Qwik Start [GSP244]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

* In the GCP Console open the Cloud Shell and enter the following commands:

```
export ZONE=
```

```
gcloud services enable file.googleapis.com

gcloud compute instances create nfs-client \
--project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium \
--network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
--metadata=enable-oslogin=true \
--maintenance-policy=MIGRATE \
--provisioning-model=STANDARD \
--scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server \
--create-disk=auto-delete=yes,boot=yes,device-name=nfs-client,image=projects/debian-cloud/global/images/debian-11-bullseye-v20231010,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any

gcloud filestore instances create nfs-server \
--zone=$ZONE --tier=BASIC_HDD \
--file-share=name="vol1",capacity=1TB \
--network=name="default"
```

# Congratulations, you're all done with the lab 😄

# Thanks for watching :)
