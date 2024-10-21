# GSP294!

# Authenticate and get the token
export OAUTH2_TOKEN=$(gcloud auth print-access-token)

export DEVSHELL_PROJECT_ID=$(gcloud config get-value project)

gcloud services enable storage.googleapis.com

gcloud config set project $DEVSHELL_PROJECT_ID


# Create the JSON file
cat > values.json << EOF
{
  "name": "${DEVSHELL_PROJECT_ID}-bucket",
  "location": "US",
  "storageClass": "MULTI_REGIONAL"
}
EOF

# Create the bucket
curl -X POST --data-binary @values.json \
    -H "Authorization: Bearer $OAUTH2_TOKEN" \
    -H "Content-Type: application/json" \
    "https://www.googleapis.com/storage/v1/b?project=$DEVSHELL_PROJECT_ID"
    

wget https://github.com/Techcps/GSP-Short-Trick/raw/master/Introduction%20to%20APIs%20in%20Google%20Cloud/demo-image.png

# Verify if the image is downloaded
if [ -f demo-image.png ]; then
    export OBJECT=$(realpath demo-image.png)

    export BUCKET_NAME=$DEVSHELL_PROJECT_ID-bucket

    export OAUTH2_TOKEN=$(gcloud auth print-access-token)

    curl -X POST --data-binary @$OBJECT \
        -H "Authorization: Bearer $OAUTH2_TOKEN" \
        -H "Content-Type: image/png" \
        "https://www.googleapis.com/upload/storage/v1/b/$BUCKET_NAME/o?uploadType=media&name=demo-image"
else
    echo "File not downloaded. Check the URL or file path."
    echo "Please like share and subscribe to techcps(https://www.youtube.com/@techcps)."
fi
