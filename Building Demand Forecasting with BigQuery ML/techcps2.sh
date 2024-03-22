
bq query --use_legacy_sql=false \
"CREATE OR REPLACE MODEL bqmlforecast.bike_model
  OPTIONS(
    MODEL_TYPE='ARIMA',
    TIME_SERIES_TIMESTAMP_COL='trip_date',
    TIME_SERIES_DATA_COL='num_trips',
    TIME_SERIES_ID_COL='start_station_id',
    HOLIDAY_REGION='US'
  ) AS
  SELECT
    trip_date,
    start_station_id,
    num_trips
  FROM
    bqmlforecast.training_data"

bq query --use_legacy_sql=false \
"SELECT
  *
FROM
  ML.EVALUATE(MODEL bqmlforecast.bike_model)"

bq query --use_legacy_sql=false \
"DECLARE HORIZON STRING DEFAULT '30'; #number of values to forecast
 DECLARE CONFIDENCE_LEVEL STRING DEFAULT '0.90';

 EXECUTE IMMEDIATE format('''
     SELECT
         *
     FROM
       ML.FORECAST(MODEL bqmlforecast.bike_model,
                   STRUCT(%s AS horizon,
                          %s AS confidence_level)
                  )
     ''', HORIZON, CONFIDENCE_LEVEL)"
