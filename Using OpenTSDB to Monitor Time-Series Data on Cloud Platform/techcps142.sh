

gcloud auth list

export REGION="${ZONE%-*}"

export PROJECT_ID=$(gcloud config get project)
gcloud config set compute/zone $ZONE

git clone https://github.com/GoogleCloudPlatform/opentsdb-bigtable.git

cd opentsdb-bigtable

export BIGTABLE_INSTANCE_ID=bt-opentsdb

gcloud bigtable instances create ${BIGTABLE_INSTANCE_ID} \
    --cluster-config=id=${BIGTABLE_INSTANCE_ID}-${ZONE},zone=${ZONE},nodes=1 \
    --display-name=OpenTSDB

gcloud container clusters create opentsdb-cluster \
--zone=$ZONE \
--machine-type e2-standard-4 \
--scopes "https://www.googleapis.com/auth/cloud-platform"    


export PROJECT_ID=$(gcloud config get project)
export REGION="${ZONE%-*}"
export AR_REPO=opentsdb-bt-repo
export BIGTABLE_INSTANCE_ID=bt-opentsdb
export ZONE=$ZONE


gcloud artifacts repositories create ${AR_REPO} \
    --repository-format=docker  \
    --location=${REGION} \
    --description="OpenTSDB on bigtable container images"


export SERVER_IMAGE_NAME=opentsdb-server-bigtable
export SERVER_IMAGE_TAG=2.4.1


gcloud builds submit \
    --tag ${REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_REPO}/${SERVER_IMAGE_NAME}:${SERVER_IMAGE_TAG} \
    build

export GEN_IMAGE_NAME=opentsdb-timeseries-generate
export GEN_IMAGE_TAG=0.1


envsubst < configmaps/opentsdb-config.yaml.tpl | kubectl create -f -

envsubst < jobs/opentsdb-init.yaml.tpl | kubectl create -f -

kubectl describe jobs

sleep 75


OPENTSDB_INIT_POD=$(kubectl get pods --selector=job-name=opentsdb-init \
                    --output=jsonpath={.items..metadata.name})
kubectl logs $OPENTSDB_INIT_POD



envsubst < deployments/opentsdb-write.yaml.tpl | kubectl create -f  -

envsubst < deployments/opentsdb-read.yaml.tpl | kubectl create -f  -

kubectl get pods

sleep 5

kubectl get pods

sleep 5

kubectl get pods

kubectl create -f services/opentsdb-write.yaml

kubectl create -f services/opentsdb-read.yaml

kubectl get services

sleep 10

kubectl get services

envsubst < deployments/generate.yaml.tpl | kubectl create -f -

kubectl create -f configmaps/grafana.yaml

kubectl get configmaps


kubectl create -f deployments/grafana.yaml

kubectl get deployments

sleep 10

kubectl get deployments


