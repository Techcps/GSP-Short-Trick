
# Building Demand Forecasting with BigQuery ML [GSP852]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps) & join our [WhatsApp Channel](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)

```
curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Building%20Demand%20Forecasting%20with%20BigQuery%20ML/techcps1.sh
sudo chmod +x techcps1.sh
./techcps1.sh
```

```
SELECT
 DATE(starttime) AS trip_date,
 start_station_id,
 COUNT(*) AS num_trips
FROM
 `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE
 starttime BETWEEN DATE('2014-01-01') AND ('2016-01-01')
 AND start_station_id IN (521,435,497,293,519)
GROUP BY
 start_station_id,
 trip_date
```

# Create Table: training_data

```
curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Building%20Demand%20Forecasting%20with%20BigQuery%20ML/techcps2.sh
sudo chmod +x techcps2.sh
./techcps2.sh
```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
