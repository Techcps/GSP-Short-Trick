
# VPC Networks - Controlling Access [GSP213]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

```
export ZONE=
```
```
export PROJECT_ID=$(gcloud config get-value project)
gcloud compute instances create blue --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --tags=web-server,http-server --create-disk=auto-delete=yes,boot=yes,device-name=blue,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230509,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any
gcloud compute instances create green --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --create-disk=auto-delete=yes,boot=yes,device-name=blue,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230509,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any
gcloud compute firewall-rules create allow-http-web-server --network=default --action=ALLOW --direction=INGRESS --source-ranges=0.0.0.0/0 --target-tags=web-server --rules=tcp:80,icmp
gcloud compute instances create test-vm --machine-type=e2-micro --subnet=default --zone=$ZONE
```

## NOTE: Go to IAM & admin > Service Accounts > Create service account
> * Service account name to "Network-admin" and click CREATE AND CONTINUE
> * Select a role > Compute Engine > Compute Network Admin and click CONTINUE then click DONE

```
gcloud iam service-accounts keys create key.json --iam-account=network-admin@$PROJECT_ID.iam.gserviceaccount.com
gcloud compute ssh blue --zone=$ZONE --quiet
```
```
sudo apt-get install nginx-light -y
sudo sed -i 's#<h1>Welcome to nginx!</h1>#<h1>Welcome to the blue server!</h1>#' /var/www/html/index.nginx-debian.html
cat /var/www/html/index.nginx-debian.html
exit
```
```
gcloud beta compute ssh green --zone=$ZONE --quiet
```
```
sudo apt-get install nginx-light -y
sudo sed -i 's#<h1>Welcome to nginx!</h1>#<h1>Welcome to the Green server!</h1>#' /var/www/html/index.nginx-debian.html
cat /var/www/html/index.nginx-debian.html
```



## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
