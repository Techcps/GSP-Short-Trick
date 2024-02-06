
export REGION=${ZONE%-*}
export PROJECT_ID=$(gcloud config get-value project)

gcloud compute addresses create mc-server-ip --region=$REGION

ADDRESS=$(gcloud compute addresses describe mc-server-ip --region=$REGION --format='value(address)')

gcloud compute instances create mc-server --zone=$ZONE --project=$PROJECT_ID --machine-type=e2-medium --network-interface=address=$ADDRESS,network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/trace.append,https://www.googleapis.com/auth/devstorage.read_write --tags=minecraft-server --create-disk=auto-delete=yes,boot=yes,device-name=mc-server,image=projects/debian-cloud/global/images/debian-11-bullseye-v20240110,mode=rw,size=10,type=projects/$PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --create-disk=device-name=minecraft-disk,mode=rw,name=minecraft-disk,size=50,type=projects/$PROJECT_ID/zones/$ZONE/diskTypes/pd-ssd --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any

gcloud compute firewall-rules create minecraft-rule --project=$PROJECT_ID --target-tags=minecraft-server --source-ranges=0.0.0.0/0 --allow=tcp:25565

gcloud compute instances add-metadata mc-server --zone=$ZONE --metadata project-id=$PROJECT_ID

gcloud compute ssh mc-server --zone=$ZONE --quiet --command "sudo mkdir -p /home/minecraft && sudo mkfs.ext4 -F -E lazy_itable_init=0,\
lazy_journal_init=0,discard \
/dev/disk/by-id/google-minecraft-disk && sudo mount -o discard,defaults /dev/disk/by-id/google-minecraft-disk /home/minecraft && sudo apt-get update && sudo apt-get install -y default-jre-headless && cd /home/minecraft && sudo apt-get install wget -y && sudo wget https://launcher.mojang.com/v1/objects/d0d0fe2b1dc6ab4c65554cb734270872b72dadd6/server.jar && sudo java -Xmx1024M -Xms1024M -jar server.jar nogui && cat > eula.txt <<'EOF_END'
GNU nano 5.4 eula.txt *
#By changing the setting below to TRUE you are indicating your agreement to our>
#Tue Feb 06 06:45:46 UTC 2024
eula=true
EOF_END && sudo apt-get install -y screen && sudo screen -S mcs java -Xmx1024M -Xms1024M -jar server.jar nogui && sudo screen -r mcs && exit"

gcloud compute ssh mc-server --zone=$ZONE --quiet --command "export PROJECT_ID=$(gcloud config get-value project) && export BUCKET_NAME=$PROJECT_ID && echo $PROJECT_ID && gcloud storage buckets create gs://$PROJECT_ID-minecraft-backup && echo BUCKET_NAME=$PROJECT_ID >> ~/.profile && cd /home/minecraft"

