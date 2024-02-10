
# Weather Data in BigQuery [GSP009]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

> In the GCP Console active your Cloud Shell and run the following commands:

```
curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Weather%20Data%20in%20BigQuery/techcps.sh
sudo chmod +x techcps.sh
./techcps.sh
```

```
SELECT
  -- Create a timestamp from the date components.
  timestamp(concat(year,"-",mo,"-",da)) as timestamp,
  -- Replace numerical null values with actual nulls
  AVG(IF (temp=9999.9, null, temp)) AS temperature,
  AVG(IF (visib=999.9, null, visib)) AS visibility,
  AVG(IF (wdsp="999.9", null, CAST(wdsp AS Float64))) AS wind_speed,
  AVG(IF (gust=999.9, null, gust)) AS wind_gust,
  AVG(IF (prcp=99.99, null, prcp)) AS precipitation,
  AVG(IF (sndp=999.9, null, sndp)) AS snow_depth
FROM
  `bigquery-public-data.noaa_gsod.gsod20*`
WHERE
  CAST(YEAR AS INT64) > 2008
  AND (stn="725030" OR  -- La Guardia
       stn="744860")    -- JFK
GROUP BY timestamp
```

# NOTE: In the query EDITOR section, click More > Query settings.

> Dataset: Type demos and select your dataset.

> Table Id: Type nyc_weather

> Results size: check Allow large results (no size limit)

> Click SAVE and RUN the query

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
