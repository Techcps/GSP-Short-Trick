
bq query --use_legacy_sql=false "SELECT bikeid, starttime, start_station_name, end_station_name FROM \`bigquery-public-data.new_york_citibike.citibike_trips\` WHERE starttime IS NOT NULL LIMIT 5;"

bq query --use_legacy_sql=false "SELECT EXTRACT(DATE FROM TIMESTAMP(starttime)) AS start_date, start_station_id, COUNT(*) AS total_trips FROM \`bigquery-public-data.new_york_citibike.citibike_trips\` WHERE starttime BETWEEN DATE('2016-01-01') AND DATE('2017-01-01') GROUP BY start_station_id, start_date LIMIT 5;"

bq --location=US mk --dataset --default_table_expiration=86400 --description "bqmlforecast dataset" $DEVSHELL_PROJECT_ID:bqmlforecast
