
gcloud auth list
gcloud config list project
gcloud config set compute/zone $ZONE
export REGION=${ZONE%-*}
gcloud config set compute/region $REGION


gcloud services enable container.googleapis.com cloudbuild.googleapis.com sourcerepo.googleapis.com --project=$DEVSHELL_PROJECT_ID

sleep 25

export PROJECT_ID=$(gcloud config get-value project)
gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")@cloudbuild.gserviceaccount.com --role="roles/container.developer"


git config --global user.email $USER_EMAIL
git config --global user.name student

export PROJECT_ID=$DEVSHELL_PROJECT_ID
export REGION="${ZONE%-*}"

export CLUSTER=hello-cluster
export REPO=my-repository

gcloud artifacts repositories create $REPO --repository-format=docker --location=$REGION --description="subscribe to techcps"


gcloud beta container --project="$PROJECT_ID" clusters create "$CLUSTER" --zone="$ZONE" --cluster-version latest --release-channel "regular" --machine-type="e2-medium" --no-enable-basic-auth --image-type "COS_CONTAINERD" --disk-type "pd-balanced" --disk-size "100" --metadata disable-legacy-endpoints=true  --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM --enable-ip-alias --network "projects/$PROJECT_ID/global/networks/default" --subnetwork "projects/$PROJECT_ID/regions/$REGION/subnetworks/default" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --enable-autoscaling --min-nodes "2" --max-nodes "6" --location-policy "BALANCED" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --enable-shielded-nodes --node-locations "$ZONE"



# Function to check if a namespace exists
namespace_exists() {
    local namespace="$1"
    kubectl get namespace "$namespace" &> /dev/null
}

# Create production namespace if it doesn't exist
if ! namespace_exists "prod"; then
    echo "Creating 'prod' namespace..."
    kubectl create namespace prod
else
    echo "'prod' namespace already exists."
fi

# Sleep for 10 seconds
sleep 10

# Create development namespace if it doesn't exist
if ! namespace_exists "dev"; then
    echo "Creating 'dev' namespace..."
    kubectl create namespace dev
else
    echo "'dev' namespace already exists."
fi


# Sleep for 10 seconds
sleep 10

# Continue with the rest of your script...
# Add your additional kubectl commands here


gcloud source repos create sample-app

git clone https://source.developers.google.com/p/$PROJECT_ID/r/sample-app


cd ~
gsutil cp -r gs://spls/gsp330/sample-app/* sample-app


## You have to run this command as well because lab is updated 

for file in sample-app/cloudbuild-dev.yaml sample-app/cloudbuild.yaml; do
    sed -i "s/<your-region>/${REGION}/g" "$file"
    sed -i "s/<your-zone>/${ZONE}/g" "$file"
done


git init
cd sample-app/
git add .
git commit -m "subscribe to techcps" 
git push -u origin master


git branch dev
git checkout dev
git push -u origin dev


gcloud builds triggers create cloud-source-repositories \
    --name="sample-app-prod-deploy" \
    --service-account="projects/$PROJECT_ID/serviceAccounts/$PROJECT_ID@$PROJECT_ID.iam.gserviceaccount.com" \
    --description="Cloud Build Trigger for production deployment" \
    --repo="sample-app" \
    --branch-pattern="^master$" \
    --build-config="cloudbuild.yaml"

# Sleep for 5 seconds
sleep 5
 
gcloud builds triggers create cloud-source-repositories \
    --name="sample-app-dev-deploy" \
    --service-account="projects/$PROJECT_ID/serviceAccounts/$PROJECT_ID@$PROJECT_ID.iam.gserviceaccount.com" \
    --description="Cloud Build Trigger for development deployment" \
    --repo="sample-app" \
    --branch-pattern="^dev$" \
    --build-config="cloudbuild-dev.yaml"


COMMIT_ID="$(git rev-parse --short=7 HEAD)"
gcloud builds submit --tag="${REGION}-docker.pkg.dev/${PROJECT_ID}/$REPO/hello-cloudbuild:${COMMIT_ID}" .

# Capture the IMAGES value into a variable
EXPORTED_IMAGE="$(gcloud builds submit --tag="${REGION}-docker.pkg.dev/${PROJECT_ID}/$REPO/hello-cloudbuild:${COMMIT_ID}" . | grep IMAGES | awk '{print $2}')"

# Print the value of the variable
echo "EXPORTED_IMAGE: ${EXPORTED_IMAGE}"

git checkout dev


sed -i "9c\    args: ['build', '-t', '$REGION-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild-dev:v1.0', '.']" cloudbuild-dev.yaml

sed -i "13c\    args: ['push', '$REGION-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild-dev:v1.0']" cloudbuild-dev.yaml

sed -i "17s|        image: <todo>|        image: $REGION-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild-dev:v1.0|" dev/deployment.yaml


git add .
git commit -m "subscribe to techcps" 
git push -u origin dev


# Sleep for 15 seconds
sleep 15


git checkout master

kubectl expose deployment development-deployment -n dev --name=dev-deployment-service --type=LoadBalancer --port 8080 --target-port 8080



sed -i "11c\    args: ['build', '-t', '$REGION-docker.pkg.dev/\$PROJECT_ID/my-repository/hello-cloudbuild:v1.0', '.']" cloudbuild.yaml

sed -i "16c\    args: ['push', '$REGION-docker.pkg.dev/\$PROJECT_ID/my-repository/hello-cloudbuild:v1.0']" cloudbuild.yaml

sed -i "17c\        image:  $REGION-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild:v1.0" prod/deployment.yaml




git add .
git commit -m "subscribe to techcps" 
git push -u origin master


# Sleep for 20 seconds
sleep 15


kubectl expose deployment production-deployment -n prod --name=prod-deployment-service --type=LoadBalancer --port 8080 --target-port 8080


git checkout dev



sed -i '28a\	http.HandleFunc("/red", redHandler)' main.go


sed -i '32a\
func redHandler(w http.ResponseWriter, r *http.Request) { \
	img := image.NewRGBA(image.Rect(0, 0, 100, 100)) \
	draw.Draw(img, img.Bounds(), &image.Uniform{color.RGBA{255, 0, 0, 255}}, image.ZP, draw.Src) \
	w.Header().Set("Content-Type", "image/png") \
	png.Encode(w, img) \
}' main.go



sed -i "9c\    args: ['build', '-t', '$REGION-docker.pkg.dev/\$PROJECT_ID/my-repository/hello-cloudbuild-dev:v2.0', '.']" cloudbuild-dev.yaml

sed -i "13c\    args: ['push', '$REGION-docker.pkg.dev/\$PROJECT_ID/my-repository/hello-cloudbuild-dev:v2.0']" cloudbuild-dev.yaml

sed -i "17c\        image: $REGION-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild:v2.0" dev/deployment.yaml


git add .
git commit -m "subscribe to techcps" 
git push -u origin dev


# Sleep for 15 seconds
sleep 15


git checkout master


sed -i '28a\	http.HandleFunc("/red", redHandler)' main.go


sed -i '32a\
func redHandler(w http.ResponseWriter, r *http.Request) { \
	img := image.NewRGBA(image.Rect(0, 0, 100, 100)) \
	draw.Draw(img, img.Bounds(), &image.Uniform{color.RGBA{255, 0, 0, 255}}, image.ZP, draw.Src) \
	w.Header().Set("Content-Type", "image/png") \
	png.Encode(w, img) \
}' main.go



sed -i "11c\    args: ['build', '-t', '$REGION-docker.pkg.dev/\$PROJECT_ID/my-repository/hello-cloudbuild:v2.0', '.']" cloudbuild.yaml

sed -i "16c\    args: ['push', '$REGION-docker.pkg.dev/\$PROJECT_ID/my-repository/hello-cloudbuild:v2.0']" cloudbuild.yaml

sed -i "17c\        image: $REGION-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild:v2.0" prod/deployment.yaml



git add .
git commit -m "subscribe to techcps" 
git push -u origin master


# Sleep for 10 seconds
sleep 10


kubectl -n prod get pods -o jsonpath --template='{range .items[*]}{.metadata.name}{"\t"}{"\t"}{.spec.containers[0].image}{"\n"}{end}'
kubectl expose deployment production-deployment -n prod --name=prod-deployment-service --type=LoadBalancer --port 8080 --target-port 8080



# Export the below variables name
export CPSPACE="prod"
export DEPLOYMENT="production-deployment"
export SERVICE="prod-deployment-service"
export PORT=8080
export TARGET_PORT=8080


expose_deployment() {
  kubectl expose deployment $DEPLOYMENT -n $CPSPACE --name=$SERVICE --type=LoadBalancer --port=$PORT --target-port=$TARGET_PORT
  return $?
}


kubectl -n $CPSPACE rollout undo deployment/$DEPLOYMENT
if [ $? -eq 0 ]; then
  echo "Successfully rolled back the deployment."
else
  echo "Failed to roll back the deployment."
fi

# Sleep for 120 seconds
sleep 120
kubectl -n $CPSPACE rollout undo deployment/$DEPLOYMENT

# Sleep for 60 seconds
sleep 60
kubectl -n $CPSPACE rollout undo deployment/$DEPLOYMENT


cd sample-app
kubectl -n prod rollout undo deployment/production-deployment



