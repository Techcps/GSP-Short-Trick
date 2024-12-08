
# Set text styles
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "Please set the below values correctly"
read -p "${YELLOW}${BOLD}Enter the ZONE: ${RESET}" ZONE

# Export variables after collecting input
export ZONE

gcloud auth list 

export REGION="${ZONE%-*}"

gcloud services enable dataproc.googleapis.com

curl -X GET \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
https://www.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/zones/$ZONE


gcloud dataproc clusters create my-cluster --project=$DEVSHELL_PROJECT_ID --region $REGION --zone $ZONE --image-version=2.0-debian10 --optional-components=JUPYTER

gcloud dataproc jobs submit spark \
    --project=$DEVSHELL_PROJECT_ID \
    --region=$REGION \
    --cluster=my-cluster \
    --class=org.apache.spark.examples.SparkPi \
    --jars=file:///usr/lib/spark/examples/jars/spark-examples.jar \
    -- 1000


gcloud dataproc clusters update my-cluster --project=$DEVSHELL_PROJECT_ID --region $REGION --num-workers=3


