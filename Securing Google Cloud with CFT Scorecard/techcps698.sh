
export GOOGLE_PROJECT=$DEVSHELL_PROJECT_ID
export CAI_BUCKET_NAME=cai-$GOOGLE_PROJECT

gcloud services enable cloudasset.googleapis.com \
    --project $GOOGLE_PROJECT


gcloud beta services identity create --service=cloudasset.googleapis.com --project=$GOOGLE_PROJECT

gcloud projects add-iam-policy-binding ${GOOGLE_PROJECT}  \
   --member=serviceAccount:service-$(gcloud projects list --filter="$GOOGLE_PROJECT" --format="value(PROJECT_NUMBER)")@gcp-sa-cloudasset.iam.gserviceaccount.com \
   --role=roles/storage.admin

git clone https://github.com/forseti-security/policy-library.git

cp policy-library/samples/storage_denylist_public.yaml policy-library/policies/constraints/

gsutil mb -l $REGION -p $GOOGLE_PROJECT gs://$CAI_BUCKET_NAME


# Export resource data
gcloud asset export \
    --output-path=gs://$CAI_BUCKET_NAME/resource_inventory.json \
    --content-type=resource \
    --project=$GOOGLE_PROJECT

# Export IAM data
gcloud asset export \
    --output-path=gs://$CAI_BUCKET_NAME/iam_inventory.json \
    --content-type=iam-policy \
    --project=$GOOGLE_PROJECT

# Export org policy data
gcloud asset export \
    --output-path=gs://$CAI_BUCKET_NAME/org_policy_inventory.json \
    --content-type=org-policy \
    --project=$GOOGLE_PROJECT

# Export access policy data
gcloud asset export \
    --output-path=gs://$CAI_BUCKET_NAME/access_policy_inventory.json \
    --content-type=access-policy \
    --project=$GOOGLE_PROJECT

