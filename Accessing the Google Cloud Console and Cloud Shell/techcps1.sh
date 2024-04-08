

gcloud storage buckets create gs://$DEVSHELL_PROJECT_ID-techcps --location=us-central1

gcloud compute zones list | grep $REGION

gcloud config set compute/zone $ZONE

MY_VMNAME=second-vm

gcloud compute instances create $MY_VMNAME \
--machine-type "e2-standard-2" \
--image-project "debian-cloud" \
--image-family "debian-11" \
--subnet "default"

gcloud iam service-accounts create test-service-account2 --display-name "test-service-account2"


gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member serviceAccount:test-service-account2@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --role roles/viewer


gsutil cp gs://cloud-training/ak8s/cat.jpg cat.jpg

gsutil cp cat.jpg gs://$DEVSHELL_PROJECT_ID

gsutil cp gs://$DEVSHELL_PROJECT_ID/cat.jpg gs://$DEVSHELL_PROJECT_ID-techcps/cat.jpg

gsutil acl get gs://$DEVSHELL_PROJECT_ID/cat.jpg  > acl.txt
cat acl.txt

gsutil acl set private gs://$DEVSHELL_PROJECT_ID/cat.jpg

gsutil acl get gs://$DEVSHELL_PROJECT_ID/cat.jpg  > acl-2.txt
cat acl-2.txt

gcloud auth activate-service-account --key-file credentials.json

gsutil cp gs://$DEVSHELL_PROJECT_ID/cat.jpg ./cat-copy.jpg

gsutil cp gs://$DEVSHELL_PROJECT_ID-techcps/cat.jpg ./cat-copy.jpg

gcloud config set account $USER_ID

gsutil cp gs://$DEVSHELL_PROJECT_ID/cat.jpg ./copy2-of-cat.jpg

gsutil iam ch allUsers:objectViewer gs://$DEVSHELL_PROJECT_ID


git clone https://github.com/googlecodelabs/orchestrate-with-kubernetes.git

mkdir test


cat > cleanup.sh <<EOF_CP
# Copyright 2016 Google Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

gcloud compute instances delete node0 node1
gcloud compute routes delete default-route-10-200-1-0-24 default-route-10-200-0-0-24
gcloud compute firewall-rules delete default-allow-local-api
echo Finished cleanup!
EOF_CP

cd orchestrate-with-kubernetes
cat cleanup.sh



