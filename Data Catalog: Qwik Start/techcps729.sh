

gcloud auth list
gcloud services disable datacatalog.googleapis.com
gcloud services enable datacatalog.googleapis.com

sleep 15

bq mk demo_dataset

bq cp bigquery-public-data:new_york_taxi_trips.tlc_yellow_trips_2018 $(gcloud config get project):demo_dataset.trips


gcloud data-catalog tag-templates create demo_tag_template \
    --location=$REGION \
    --display-name="Demo Tag Template" \
    --field=id=source_of_data_asset,display-name="Source of data asset",type=string,required=TRUE \
    --field=id=number_of_rows_in_data_asset,display-name="Number of rows in data asset",type=double \
    --field=id=has_pii,display-name="Has PII",type=bool \
    --field=id=pii_type,display-name="PII type",type='enum(Email|Social Security Number|None)'


CP=$(gcloud data-catalog entries lookup '//bigquery.googleapis.com/projects/'$DEVSHELL_PROJECT_ID'/datasets/demo_dataset/tables/trips' --format="value(name)")


cat > tag_file.json << EOF_CP
  {
    "source_of_data_asset": "tlc_yellow_trips_2018",
    "pii_type": "None"
  }
EOF_CP

gcloud data-catalog tags create --entry=${CP} --tag-template-location=$REGION --tag-template=demo_tag_template --tag-file=tag_file.json



