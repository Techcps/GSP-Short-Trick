

gcloud auth list

gcloud config set compute/zone $ZONE 

export REGION=${ZONE%-*}
gcloud config set compute/region $REGION

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud compute instances create dev-instance --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-standard-2 --scopes=https://www.googleapis.com/auth/cloud-platform --tags=http-server --create-disk=auto-delete=yes,boot=yes,image=projects/debian-cloud/global/images/family/debian-11,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any

gcloud compute firewall-rules create allow-http --action=ALLOW --direction=INGRESS --description "Allow HTTP traffic" --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server

sleep 10

cat > techcps.sh <<'EOF_CP'
sudo apt-get update
sudo apt-get install git -y
sudo apt-get install python3-setuptools python3-dev build-essential -y
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
python3 --version
pip3 --version
git clone https://github.com/GoogleCloudPlatform/training-data-analyst
ln -s ~/training-data-analyst/courses/developingapps/v1.3/python/devenv ~/devenv
cd ~/devenv/
sudo python3 server.py
EOF_CP

sleep 10

gcloud compute scp techcps.sh dev-instance:/tmp --project="$DEVSHELL_PROJECT_ID" --zone="$ZONE" --quiet

gcloud compute ssh dev-instance --project="$DEVSHELL_PROJECT_ID" --zone="$ZONE" --quiet --command='bash /tmp/techcps.sh'

