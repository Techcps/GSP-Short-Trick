

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gsutil mb gs://$DEVSHELL_PROJECT_ID-bucket

curl -L -o demo-image.jpg https://github.com/Techcps/GSP-Short-Trick/blob/main/APIs%20Explorer%3A%20Qwik%20Start/demo-image.jpg

gsutil cp demo-image.jpg gs://$DEVSHELL_PROJECT_ID-bucket/demo-image.jpg

gsutil acl ch -u allUsers:R gs://$DEVSHELL_PROJECT_ID-bucket/demo-image.jpg

