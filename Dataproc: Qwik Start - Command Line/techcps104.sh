
gcloud auth list

gcloud config set dataproc/region $REGION

gcloud compute zones list --filter="region:($REGION)"
export ZONE=$(gcloud compute zones list --filter="region:($REGION)" --format="value(name)" | head -n 1)


PROJECT_ID=$(gcloud config get-value project) && \
gcloud config set project $PROJECT_ID

PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member=serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
  --role=roles/storage.admin

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
    --role roles/storage.objectAdmin

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
    --role roles/dataproc.worker


gcloud compute networks subnets update default \
    --region $REGION \
    --enable-private-ip-google-access


gcloud dataproc clusters create example-cluster --region $REGION --zone $ZONE --worker-boot-disk-size 500 --worker-machine-type=e2-standard-4 --master-machine-type=e2-standard-4



gcloud dataproc jobs submit spark --cluster example-cluster --region $REGION \
  --class org.apache.spark.examples.SparkPi \
  --jars file:///usr/lib/spark/examples/jars/spark-examples.jar -- 1000





