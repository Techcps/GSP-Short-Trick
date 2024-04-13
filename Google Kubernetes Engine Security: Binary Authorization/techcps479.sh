
export REGION="${ZONE%-*}"
export PROJECT_ID="$(gcloud config get-value project)"

gcloud services enable compute.googleapis.com --project=$DEVSHELL_PROJECT_ID
gcloud services enable container.googleapis.com --project=$DEVSHELL_PROJECT_ID
gcloud services enable containerregistry.googleapis.com --project=$DEVSHELL_PROJECT_ID
gcloud services enable containeranalysis.googleapis.com --project=$DEVSHELL_PROJECT_ID
gcloud services enable binaryauthorization.googleapis.com --project=$DEVSHELL_PROJECT_ID

sleep 45

gsutil -m cp -r gs://spls/gke-binary-auth/* .

cd gke-binary-auth-demo

gcloud config set compute/region $REGION    
gcloud config set compute/zone $ZONE

chmod +x create.sh
chmod +x delete.sh
chmod 777 validate.sh

sed -i 's/validMasterVersions\[0\]/defaultClusterVersion/g' ./create.sh

./create.sh -c my-cluster-1

./validate.sh -c my-cluster-1

gcloud beta container binauthz policy export > policy.yaml

cat > policy.yaml <<EOF_CP
defaultAdmissionRule:
  enforcementMode: ENFORCED_BLOCK_AND_AUDIT_LOG
  evaluationMode: ALWAYS_DENY
globalPolicyEvaluationMode: ENABLE
clusterAdmissionRules:
  $ZONE.my-cluster-1:
    evaluationMode: ALWAYS_ALLOW
    enforcementMode: ENFORCED_BLOCK_AND_AUDIT_LOG
name: projects/$PROJECT_ID/policy
EOF_CP

gcloud beta container binauthz policy import policy.yaml


docker pull gcr.io/google-containers/nginx:latest

gcloud auth configure-docker --quiet

PROJECT_ID="$(gcloud config get-value project)"

docker tag gcr.io/google-containers/nginx "gcr.io/${PROJECT_ID}/nginx:latest"
docker push "gcr.io/${PROJECT_ID}/nginx:latest"

gcloud container images list-tags "gcr.io/${PROJECT_ID}/nginx"

cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: "gcr.io/${PROJECT_ID}/nginx:latest"
    ports:
    - containerPort: 80
EOF

kubectl get pods

kubectl delete pod nginx

gcloud beta container binauthz policy export > policy.yaml

cat > policy.yaml <<EOF_CP
defaultAdmissionRule:
  enforcementMode: ENFORCED_BLOCK_AND_AUDIT_LOG
  evaluationMode: ALWAYS_DENY
globalPolicyEvaluationMode: ENABLE
clusterAdmissionRules:
  $ZONE.my-cluster-1:
    evaluationMode: ALWAYS_DENY
    enforcementMode: ENFORCED_BLOCK_AND_AUDIT_LOG
name: projects/$PROJECT_ID/policy
EOF_CP

gcloud beta container binauthz policy import policy.yaml



cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: "gcr.io/${PROJECT_ID}/nginx:latest"
    ports:
    - containerPort: 80
EOF


resource.type="k8s_cluster" protoPayload.response.reason="VIOLATES_POLICY"


# Filter logs by resource type
gcloud logging read "resource.type='k8s_cluster'  AND protoPayload.response.reason='VIOLATES_POLICY'" --project=$PROJECT_ID

# Run a specific query
gcloud logging read "resource.type='k8s_cluster'  AND protoPayload.response.reason='VIOLATES_POLICY'" --project=$PROJECT_ID --format=json


IMAGE_PATH=$(echo "gcr.io/${PROJECT_ID}/nginx*")


cat > policy.yaml <<EOF_CP
defaultAdmissionRule:
  enforcementMode: ENFORCED_BLOCK_AND_AUDIT_LOG
  evaluationMode: ALWAYS_DENY
globalPolicyEvaluationMode: ENABLE
clusterAdmissionRules:
  $ZONE.my-cluster-1:
    evaluationMode: ALWAYS_DENY
    enforcementMode: ENFORCED_BLOCK_AND_AUDIT_LOG
admissionWhitelistPatterns:
- namePattern: "gcr.io/${PROJECT_ID}/nginx*"
name: projects/$PROJECT_ID/policy
EOF_CP

gcloud beta container binauthz policy import policy.yaml


cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: "gcr.io/${PROJECT_ID}/nginx:latest"
    ports:
    - containerPort: 80
EOF


kubectl delete pod nginx


ATTESTOR="manually-verified" # No spaces allowed
ATTESTOR_NAME="Manual Attestor"
ATTESTOR_EMAIL="$(gcloud config get-value core/account)" # This uses your current user/email

NOTE_ID="Human-Attestor-Note" # No spaces
NOTE_DESC="Human Attestation Note Demo"


NOTE_PAYLOAD_PATH="note_payload.json"
IAM_REQUEST_JSON="iam_request.json"



cat > ${NOTE_PAYLOAD_PATH} << EOF
{
  "name": "projects/${PROJECT_ID}/notes/${NOTE_ID}",
  "attestation_authority": {
    "hint": {
      "human_readable_name": "${NOTE_DESC}"
    }
  }
}
EOF


curl -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $(gcloud auth print-access-token)"  \
    --data-binary @${NOTE_PAYLOAD_PATH}  \
    "https://containeranalysis.googleapis.com/v1beta1/projects/${PROJECT_ID}/notes/?noteId=${NOTE_ID}"

curl -H "Authorization: Bearer $(gcloud auth print-access-token)"  \
    "https://containeranalysis.googleapis.com/v1beta1/projects/${PROJECT_ID}/notes/${NOTE_ID}"



PGP_PUB_KEY="generated-key.pgp"

sudo apt-get install rng-tools -y

sudo rngd -r /dev/urandom -y


gpg --quick-generate-key --yes ${ATTESTOR_EMAIL}

sleep 10


gpg --armor --export "${ATTESTOR_EMAIL}" > ${PGP_PUB_KEY}


gcloud --project="${PROJECT_ID}" \
    beta container binauthz attestors create "${ATTESTOR}" \
    --attestation-authority-note="${NOTE_ID}" \
    --attestation-authority-note-project="${PROJECT_ID}"

gcloud --project="${PROJECT_ID}" \
    beta container binauthz attestors public-keys add \
    --attestor="${ATTESTOR}" \
    --pgp-public-key-file="${PGP_PUB_KEY}"

gcloud --project="${PROJECT_ID}" \
    beta container binauthz attestors list

GENERATED_PAYLOAD="generated_payload.json"
GENERATED_SIGNATURE="generated_signature.pgp"

PGP_FINGERPRINT="$(gpg --list-keys ${ATTESTOR_EMAIL} | head -2 | tail -1 | awk '{print $1}')"

IMAGE_PATH="gcr.io/${PROJECT_ID}/nginx"
IMAGE_DIGEST="$(gcloud container images list-tags --format='get(digest)' $IMAGE_PATH | head -1)"


gcloud beta container binauthz create-signature-payload \
    --artifact-url="${IMAGE_PATH}@${IMAGE_DIGEST}" > ${GENERATED_PAYLOAD}

sleep 5

cat "${GENERATED_PAYLOAD}"

gpg --local-user "${ATTESTOR_EMAIL}" \
    --armor \
    --output ${GENERATED_SIGNATURE} \
    --sign ${GENERATED_PAYLOAD}

sleep 5

cat "${GENERATED_SIGNATURE}"

gcloud beta container binauthz attestations create \
    --artifact-url="${IMAGE_PATH}@${IMAGE_DIGEST}" \
    --attestor="projects/${PROJECT_ID}/attestors/${ATTESTOR}" \
    --signature-file=${GENERATED_SIGNATURE} \
    --public-key-id="${PGP_FINGERPRINT}"

gcloud beta container binauthz attestations list \
    --attestor="projects/${PROJECT_ID}/attestors/${ATTESTOR}"

echo "projects/${PROJECT_ID}/attestors/${ATTESTOR}" # Copy this output to your copy/paste buffer     



