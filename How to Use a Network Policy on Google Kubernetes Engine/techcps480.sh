
# Set text styles
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "Please set the below values correctly"
read -p "${YELLOW}${BOLD}Enter the ZONE: ${RESET}" ZONE

gcloud config set compute/zone $ZONE

export REGION="${ZONE%-*}"

gcloud config set compute/region $REGION

gsutil cp -r gs://spls/gsp480/gke-network-policy-demo .


cd gke-network-policy-demo

chmod -R 755 *


echo "y" | make setup-project

echo "yes" | make tf-apply

echo "export ZONE=$ZONE" > cp.sh

source cp.sh

cat > techcps.sh <<'EOF_CP'

source /tmp/cp.sh

sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin -y

echo "export USE_GKE_GCLOUD_AUTH_PLUGIN=True" >> ~/.bashrc

source ~/.bashrc

gcloud container clusters get-credentials gke-demo-cluster --zone $ZONE

kubectl apply -f ./manifests/hello-app/

kubectl apply -f ./manifests/network-policy.yaml

kubectl delete -f ./manifests/network-policy.yaml

kubectl create -f ./manifests/network-policy-namespaced.yaml

kubectl -n hello-apps apply -f ./manifests/hello-app/hello-client.yaml

EOF_CP


gcloud compute scp cp.sh gke-demo-bastion:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute scp techcps.sh gke-demo-bastion:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh gke-demo-bastion --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/techcps.sh"

