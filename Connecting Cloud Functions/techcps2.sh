

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud config set compute/zone $ZONE
export REGION="${ZONE%-*}"
gcloud config set compute/region $REGION

export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format='value(projectNumber)')
gcloud config set project $DEVSHELL_PROJECT_ID



REDIS_INSTANCE=customerdb

gcloud redis instances describe $REDIS_INSTANCE --region=$REGION

REDIS_IP=$(gcloud redis instances describe $REDIS_INSTANCE --region=$REGION --format="value(host)"); echo $REDIS_IP

REDIS_PORT=$(gcloud redis instances describe $REDIS_INSTANCE --region=$REGION --format="value(port)"); echo $REDIS_PORT


mkdir ~/redis-http && cd $_
touch main.py && touch requirements.txt


cat > main.py <<'EOF_CP'
import os
import redis
from flask import request
import functions_framework

redis_host = os.environ.get('REDISHOST', 'localhost')
redis_port = int(os.environ.get('REDISPORT', 6379))
redis_client = redis.StrictRedis(host=redis_host, port=redis_port)

@functions_framework.http
def getFromRedis(request):
    response_data = ""
    if request.method == 'GET':
        id = request.args.get('id')
        try:
            response_data = redis_client.get(id)
        except RuntimeError:
            response_data = ""
        if response_data is None:
            response_data = ""
    return response_data
EOF_CP


cat > requirements.txt <<EOF_CP
functions-framework==3.2.0
redis==4.3.4
EOF_CP


deploy_function() {
gcloud functions deploy http-get-redis \
--gen2 \
--runtime python310 \
--entry-point getFromRedis \
--source . \
--region $REGION \
--trigger-http \
--timeout 600s \
--max-instances 1 \
--vpc-connector projects/$PROJECT_ID/locations/$REGION/connectors/test-connector \
--set-env-vars REDISHOST=$REDIS_IP,REDISPORT=$REDIS_PORT \
--no-allow-unauthenticated
}

deploy_success=false

while [ "$deploy_success" = false ]; do
    if deploy_function; then
        echo "Function deployed successfully."
        deploy_success=true
    else
        echo "Retrying in 10 seconds, subscribe to techcps [https://www.youtube.com/@techcps]"
        sleep 10
    fi
done


FUNCTION_URI=$(gcloud functions describe http-get-redis --gen2 --region $REGION --format "value(serviceConfig.uri)"); echo $FUNCTION_URI

curl -H "Authorization: bearer $(gcloud auth print-identity-token)" "${FUNCTION_URI}?id=1234"

gsutil cp gs://cloud-training/CBL492/startup.sh .

cat startup.sh

gcloud compute instances create webserver-vm \
--image-project=debian-cloud \
--image-family=debian-11 \
--metadata-from-file=startup-script=./startup.sh \
--machine-type e2-standard-2 \
--tags=http-server \
--scopes=https://www.googleapis.com/auth/cloud-platform \
--zone $ZONE


gcloud compute --project=$PROJECT_ID \
 firewall-rules create default-allow-http \
 --direction=INGRESS \
 --priority=1000 \
 --network=default \
 --action=ALLOW \
 --rules=tcp:80 \
 --source-ranges=0.0.0.0/0 \
 --target-tags=http-server


sleep 30


VM_INT_IP=$(gcloud compute instances describe webserver-vm --format='get(networkInterfaces[0].networkIP)' --zone $ZONE); echo $VM_INT_IP

VM_EXT_IP=$(gcloud compute instances describe webserver-vm --format='get(networkInterfaces[0].accessConfigs[0].natIP)' --zone $ZONE); echo $VM_EXT_IP



mkdir ~/vm-http && cd $_
touch main.py && touch requirements.txt


cat > main.py <<'EOF_CP'
import functions_framework
import requests

@functions_framework.http
def connectVM(request):
    resp_text = ""
    if request.method == 'GET':
        ip = request.args.get('ip')
        try:
            response_data = requests.get(f"http://{ip}")
            resp_text = response_data.text
        except RuntimeError:
            print ("Error while connecting to VM")
    return resp_text
EOF_CP



cat > requirements.txt <<EOF_END
functions-framework==3.2.0
Werkzeug==2.3.7
flask==2.1.3
requests==2.28.1
EOF_END



deploy_function() {
gcloud functions deploy vm-connector \
 --runtime python310 \
 --entry-point connectVM \
 --source . \
 --region $REGION \
 --trigger-http \
 --timeout 10s \
 --max-instances 1 \
 --no-allow-unauthenticated
}

deploy_success=false

while [ "$deploy_success" = false ]; do
    if deploy_function; then
        echo "Function deployed successfully."
        deploy_success=true
    else
        echo "Retrying in 10 seconds, subscribe to techcps [https://www.youtube.com/@techcps]"
        sleep 10
    fi
done


FUNCTION_URI=$(gcloud functions describe vm-connector --region $REGION --format='value(httpsTrigger.url)'); echo $FUNCTION_URI

curl -H "Authorization: bearer $(gcloud auth print-identity-token)" "${FUNCTION_URI}?ip=$VM_INT_IP"


curl -H "Authorization: bearer $(gcloud auth print-identity-token)" "${FUNCTION_URI}?ip=$VM_EXT_IP"


gcloud services disable cloudfunctions.googleapis.com

gcloud services enable cloudfunctions.googleapis.com


sleep 30


cd ~
cd vm-http

export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format='value(projectNumber)')
export PROJECT_ID=$(gcloud config get-value project)

deploy_function() {
    gcloud functions deploy vm-connector \
        --runtime python310 \
        --entry-point connectVM \
        --source . \
        --region $REGION \
        --trigger-http \
        --timeout 10s \
        --max-instances 1 \
        --no-allow-unauthenticated \
        --vpc-connector projects/$PROJECT_ID/locations/$REGION/connectors/test-connector \
        --service-account "$PROJECT_NUMBER-compute@developer.gserviceaccount.com"
}

deploy_success=false

export SERVICE_NAME="vm-connector"

while [ "$deploy_success" = false ]; do
    deploy_function
    if gcloud functions describe $SERVICE_NAME --region=$REGION &> /dev/null; then
        echo "Function deployed successfully."
        deploy_success=true
    else
        echo "Retrying in 10 seconds, subscribe to techcps [https://www.youtube.com/@techcps]"
        sleep 10
    fi
done


curl -H "Authorization: bearer $(gcloud auth print-identity-token)" "${FUNCTION_URI}?ip=$VM_INT_IP"

export TOPIC=add_redis

gcloud pubsub topics publish $TOPIC --message='{"id": 1234, "firstName": "Lucas" ,"lastName": "Sherman", "Phone": "555-555-5555"}'
 
