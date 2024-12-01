

gcloud auth list

gcloud services enable apikeys.googleapis.com

gcloud alpha services api-keys create --display-name="techcps"

KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=techcps")

API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")

echo $API_KEY

