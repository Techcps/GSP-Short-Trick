
bq query --use_legacy_sql=false \
--destination_table demo_dataset.authorized_table \
'SELECT * FROM (
SELECT *, ROW_NUMBER() OVER (PARTITION BY state_code ORDER BY area_land_meters DESC) AS cities_by_area
FROM `bigquery-public-data.geo_us_boundaries.zip_codes`) cities
WHERE cities_by_area <= 10 ORDER BY cities.state_code
LIMIT 1000;'

echo "SHARED ID : $DEVSHELL_PROJECT_ID"
