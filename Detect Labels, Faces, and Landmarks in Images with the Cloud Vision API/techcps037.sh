

gcloud auth list

gcloud alpha services api-keys create --display-name="techcps" 

KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=techcps")

export API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")

export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

gsutil mb gs://$PROJECT_ID


curl -L -o donuts.png https://github.com/Techcps/GSP-Short-Trick/master/Detect%20Labels%2C%20Faces%2C%20and%20Landmarks%20in%20Images%20with%20the%20Cloud%20Vision%20API%20GSP037/donuts.png

curl -L -o selfie.png https://github.com/Techcps/GSP-Short-Trick/master/Detect%20Labels%2C%20Faces%2C%20and%20Landmarks%20in%20Images%20with%20the%20Cloud%20Vision%20API%20GSP037/selfie.png

curl -L -o city.png https://github.com/Techcps/GSP-Short-Trick/master/Detect%20Labels%2C%20Faces%2C%20and%20Landmarks%20in%20Images%20with%20the%20Cloud%20Vision%20API%20GSP037/city.png


gsutil cp donuts.png gs://$PROJECT_ID/donuts.png

gsutil cp selfie.png gs://$PROJECT_ID/selfie.png

gsutil cp city.png gs://$PROJECT_ID/city.png

gcloud storage objects update gs://$PROJECT_ID/donuts.png --add-acl-grant=entity=AllUsers,role=READER

gcloud storage objects update gs://$PROJECT_ID/selfie.png --add-acl-grant=entity=AllUsers,role=READER

gcloud storage objects update gs://$PROJECT_ID/city.png --add-acl-grant=entity=AllUsers,role=READER

