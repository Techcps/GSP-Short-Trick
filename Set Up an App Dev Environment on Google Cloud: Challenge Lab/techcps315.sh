#GSP315



gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")

gcloud config set compute/zone $ZONE

gcloud config set compute/region $REGION

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud config set project $DEVSHELL_PROJECT_ID





gcloud services enable artifactregistry.googleapis.com logging.googleapis.com pubsub.googleapis.com cloudfunctions.googleapis.com cloudbuild.googleapis.com eventarc.googleapis.com run.googleapis.com --project=$DEVSHELL_PROJECT_ID

sleep 60


PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format='value(projectNumber)')

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member=serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
    --role=roles/eventarc.eventReceiver

sleep 20

SERVICE_ACCOUNT="$(gsutil kms serviceaccount -p $DEVSHELL_PROJECT_ID)"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member="serviceAccount:${SERVICE_ACCOUNT}" \
    --role='roles/pubsub.publisher'

sleep 20

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com \
    --role=roles/iam.serviceAccountTokenCreator

sleep 20

gsutil mb -l $REGION gs://$DEVSHELL_PROJECT_ID-bucket

gcloud pubsub topics create $TOPIC_NAME

mkdir techcps
cd techcps


cat > index.js <<'EOF_CP'
const functions = require('@google-cloud/functions-framework');
const crc32 = require("fast-crc32c");
const { Storage } = require('@google-cloud/storage');
const gcs = new Storage();
const { PubSub } = require('@google-cloud/pubsub');
const imagemagick = require("imagemagick-stream");

functions.cloudEvent('$FUNCTION_NAME', cloudEvent => {
  const event = cloudEvent.data;

  console.log(`Event: ${event}`);
  console.log(`Hello ${event.bucket}`);

  const fileName = event.name;
  const bucketName = event.bucket;
  const size = "64x64"
  const bucket = gcs.bucket(bucketName);
  const topicName = "$TOPIC_NAME";
  const pubsub = new PubSub();
  if ( fileName.search("64x64_thumbnail") == -1 ){
    // doesn't have a thumbnail, get the filename extension
    var filename_split = fileName.split('.');
    var filename_ext = filename_split[filename_split.length - 1];
    var filename_without_ext = fileName.substring(0, fileName.length - filename_ext.length );
    if (filename_ext.toLowerCase() == 'png' || filename_ext.toLowerCase() == 'jpg'){
      // only support png and jpg at this point
      console.log(`Processing Original: gs://${bucketName}/${fileName}`);
      const gcsObject = bucket.file(fileName);
      let newFilename = filename_without_ext + size + '_thumbnail.' + filename_ext;
      let gcsNewObject = bucket.file(newFilename);
      let srcStream = gcsObject.createReadStream();
      let dstStream = gcsNewObject.createWriteStream();
      let resize = imagemagick().resize(size).quality(90);
      srcStream.pipe(resize).pipe(dstStream);
      return new Promise((resolve, reject) => {
        dstStream
          .on("error", (err) => {
            console.log(`Error: ${err}`);
            reject(err);
          })
          .on("finish", () => {
            console.log(`Success: ${fileName} → ${newFilename}`);
              // set the content-type
              gcsNewObject.setMetadata(
              {
                contentType: 'image/'+ filename_ext.toLowerCase()
              }, function(err, apiResponse) {});
              pubsub
                .topic(topicName)
                .publisher()
                .publish(Buffer.from(newFilename))
                .then(messageId => {
                  console.log(`Message ${messageId} published.`);
                })
                .catch(err => {
                  console.error('ERROR:', err);
                });
          });
      });
    }
    else {
      console.log(`gs://${bucketName}/${fileName} is not an image I can handle`);
    }
  }
  else {
    console.log(`gs://${bucketName}/${fileName} already has a thumbnail`);
  }
});
EOF_CP

sed -i "8c\functions.cloudEvent('$FUNCTION_NAME', cloudEvent => { " index.js

sed -i "18c\  const topicName = '$TOPIC_NAME';" index.js

cat > package.json <<EOF_CP
{
    "name": "thumbnails",
    "version": "1.0.0",
    "description": "Create Thumbnail of uploaded image",
    "scripts": {
      "start": "node index.js"
    },
    "dependencies": {
      "@google-cloud/functions-framework": "^3.0.0",
      "@google-cloud/pubsub": "^2.0.0",
      "@google-cloud/storage": "^5.0.0",
      "fast-crc32c": "1.0.4",
      "imagemagick-stream": "4.1.1"
    },
    "devDependencies": {},
    "engines": {
      "node": ">=4.3.2"
    }
  }
EOF_CP


PROJECT_ID=$(gcloud config get-value project)
BUCKET_SERVICE_ACCOUNT="${PROJECT_ID}@${PROJECT_ID}.iam.gserviceaccount.com"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member=serviceAccount:$BUCKET_SERVICE_ACCOUNT \
  --role=roles/pubsub.publisher


deploy_function() {
    gcloud functions deploy $FUNCTION_NAME \
    --gen2 \
    --runtime nodejs20 \
    --trigger-resource $DEVSHELL_PROJECT_ID-bucket \
    --trigger-event google.storage.object.finalize \
    --region=$REGION \
    --entry-point $FUNCTION_NAME \
    --source . \
    --quiet
}

SERVICE_NAME="$FUNCTION_NAME"

while true; do
  deploy_function
  if gcloud run services describe $SERVICE_NAME --region $REGION &> /dev/null; then
    echo "Function deployed successfully https://www.youtube.com/@techcps"
    break
  else
    echo "please subscribe to techcps https://www.youtube.com/@techcps"
    sleep 20
  fi
done



curl -o map.jpg https://storage.googleapis.com/cloud-training/gsp315/map.jpg

gsutil cp map.jpg gs://$DEVSHELL_PROJECT_ID-bucket/map.jpg

gcloud projects remove-iam-policy-binding $DEVSHELL_PROJECT_ID \
--member=user:$USER2 \
--role=roles/viewer



