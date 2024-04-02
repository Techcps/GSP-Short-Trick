

export BUCKET=$(gcloud config get-value project)

gsutil mb "gs://$BUCKET"

sleep 5

gsutil retention set 10s "gs://$BUCKET"

gsutil retention get "gs://$BUCKET"

gsutil cp gs://spls/gsp297/dummy_transactions "gs://$BUCKET/"

gsutil ls -L "gs://$BUCKET/dummy_transactions"

sleep 5

gsutil retention lock "gs://$BUCKET/"

gsutil retention temp set "gs://$BUCKET/dummy_transactions"


gsutil rm "gs://$BUCKET/dummy_transactions"

gsutil retention temp release "gs://$BUCKET/dummy_transactions"


gsutil retention event-default set "gs://$BUCKET/"

gsutil cp gs://spls/gsp297/dummy_loan "gs://$BUCKET/"

gsutil ls -L "gs://$BUCKET/dummy_loan"

gsutil retention event release "gs://$BUCKET/dummy_loan"

gsutil ls -L "gs://$BUCKET/dummy_loan"

