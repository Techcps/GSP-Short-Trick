

PROJECT_ID=$(gcloud config get-value project)
DATASET_ID="billing_dataset"

TABLE_NAME="sampleinfotable"
SOURCE_GCS_URI="gs://cloud-training/archinfra/BillingExport-2020-09-18.avro"

bq --location=US mk --dataset \
  --default_table_expiration=86400 \
  ${PROJECT_ID}:${DATASET_ID}


bq load \
  --source_format=AVRO \
  ${DATASET_ID}.${TABLE_NAME} \
  ${SOURCE_GCS_URI}



bq query --use_legacy_sql=false \
'SELECT * FROM `billing_dataset.sampleinfotable` 
 WHERE Cost > 0'


bq query --use_legacy_sql=false '
SELECT
  billing_account_id,
  project.id,
  project.name,
  service.description,
  currency,
  currency_conversion_rate,
  cost,
  usage.amount,
  usage.pricing_unit
FROM
  `billing_dataset.sampleinfotable`
'


bq query --use_legacy_sql=false '
SELECT
  service.description,
  sku.description,
  location.country,
  cost,
  project.id,
  project.name,
  currency,
  currency_conversion_rate,
  usage.amount,
  usage.unit
FROM
  `billing_dataset.sampleinfotable`
WHERE
  cost > 0
ORDER BY usage_end_time DESC
LIMIT
  100
'


bq query --use_legacy_sql=false '
SELECT
  service.description,
  sku.description,
  location.country,
  cost,
  project.id,
  project.name,
  currency,
  currency_conversion_rate,
  usage.amount,
  usage.unit
FROM
  `billing_dataset.sampleinfotable`
WHERE
  cost > 10
'


bq query --use_legacy_sql=false \
'SELECT
  service.description,
  COUNT(*) AS billing_records
FROM
  `billing_dataset.sampleinfotable`
GROUP BY
  service.description
ORDER BY billing_records DESC'



bq query --use_legacy_sql=false '
SELECT
  service.description,
  COUNT(*) AS billing_records
FROM
  `billing_dataset.sampleinfotable`
WHERE
  cost > 1
GROUP BY
  service.description
ORDER BY
  billing_records DESC
'


bq query --use_legacy_sql=false '
SELECT
  usage.unit,
  COUNT(*) AS billing_records
FROM
  `billing_dataset.sampleinfotable`
WHERE cost > 0
GROUP BY
  usage.unit
ORDER BY
  billing_records DESC'



bq query --use_legacy_sql=false \
"SELECT
  service.description,
  ROUND(SUM(cost), 2) AS total_cost
FROM
  \`billing_dataset.sampleinfotable\`
GROUP BY
  service.description
ORDER BY
  total_cost DESC"



bq query --use_legacy_sql=false "
SELECT
  service.description,
  ROUND(SUM(cost),2) AS total_cost
FROM
  \`billing_dataset.sampleinfotable\`
GROUP BY
  service.description
ORDER BY
  total_cost DESC"



