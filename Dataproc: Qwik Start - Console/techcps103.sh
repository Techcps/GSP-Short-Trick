
gcloud auth list

export REGION="${ZONE%-*}"

gcloud config set dataproc/region $REGION

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

export PROJECT_NUMBER="$(gcloud projects describe $DEVSHELL_PROJECT_ID --format='get(projectNumber)')"

gcloud services enable dataproc.googleapis.com

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
  --role=roles/storage.admin

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
    --role=roles/dataproc.worker

gcloud compute networks subnets update default \
    --region=$REGION \
    --enable-private-ip-google-access  


gcloud dataproc clusters create example-cluster \
--region=$REGION \
--zone=$ZONE \
--master-machine-type=e2-standard-2 \
--master-boot-disk-size=50GB \
--num-workers=2 \
--worker-machine-type=e2-standard-2 \
--worker-boot-disk-size=50GB
 

gcloud dataproc jobs submit spark \
  --region=$REGION \
  --cluster=example-cluster \
  --class=org.apache.spark.examples.SparkPi \
  --jars=file:///usr/lib/spark/examples/jars/spark-examples.jar \
  -- 1000

gcloud dataproc clusters update example-cluster \
--num-workers=4 \
--region=$REGION

