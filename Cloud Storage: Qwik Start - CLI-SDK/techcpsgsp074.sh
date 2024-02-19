
gcloud auth list
gcloud config list project
export PROJECT_ID=$(gcloud config get-value project)

gsutil mb gs://$PROJECT_ID-techcps

curl https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Ada_Lovelace_portrait.jpg/800px-Ada_Lovelace_portrait.jpg --output ada.jpg

gsutil cp ada.jpg gs://$PROJECT_ID-techcps

rm ada.jpg

gsutil cp -r gs://$PROJECT_ID-techcps/ada.jpg .

gsutil cp gs://$PROJECT_ID-techcps/ada.jpg gs://$PROJECT_ID-techcps/image-folder/

gsutil ls gs://$PROJECT_ID-techcps

gsutil ls -l gs://$PROJECT_ID-techcps/ada.jpg

gsutil acl ch -u AllUsers:R gs://$PROJECT_ID-techcps/ada.jpg

