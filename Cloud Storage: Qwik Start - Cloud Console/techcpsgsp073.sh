
gsutil mb -l $REGION -c Standard gs://$DEVSHELL_PROJECT_ID

curl -o https://github.com/Techcps/GSP-Short-Trick/blob/main/Cloud%20Storage%3A%20Qwik%20Start%20-%20Cloud%20Console/kitten.png

gsutil cp kitten.png gs://$DEVSHELL_PROJECT_ID/kitten.png

gsutil iam ch allUsers:objectViewer gs://$DEVSHELL_PROJECT_ID
