
bq mk --dataset --location=US imported_billing_data

bq load --autodetect --skip_leading_rows=1 imported_billing_data.sampleinfotable gs://cloud-training/archinfra/export-billing-example.csv

bq query --use_legacy_sql=true 'SELECT * FROM [imported_billing_data.sampleinfotable] WHERE Cost > 0'
