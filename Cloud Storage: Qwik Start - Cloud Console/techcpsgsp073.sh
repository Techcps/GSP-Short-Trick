
gsutil mb -l $REGION -c Standard gs://$DEVSHELL_PROJECT_ID


gsutil cp kitten.png gs://$DEVSHELL_PROJECT_ID/kitten.png

gsutil iam ch allUsers:objectViewer gs://$DEVSHELL_PROJECT_ID
