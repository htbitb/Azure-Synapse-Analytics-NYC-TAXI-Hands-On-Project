USE nyc_taxi_discovery
GO

-- Number of trips made by duration in hours
SELECT TOP 100
    lpep_pickup_datetime,
    lpep_dropoff_datetime,
    DATEDIFF (minute, lpep_pickup_datetime, lpep_dropoff_datetime) / 60 AS from_hour
FROM
OPENROWSET
(
    BULK 'trip_data_green_parquet/year=2020/month=01/*.parquet',
    FORMAT = 'PARQUET',
    DATA_SOURCE = 'nyc_taxi_data_raw'
) AS [result]
GO