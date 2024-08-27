USE nyc_taxi_discovery
GO

-- Identify any data quality issues in trip total amount
SELECT TOP 100 *
FROM
OPENROWSET
(
    BULK 'trip_data_green_parquet/year=2020/month=01/*.parquet',
    FORMAT = 'PARQUET',
    DATA_SOURCE = 'nyc_taxi_data_raw'
) AS [result]
GO

SELECT
    MIN(total_amount) AS min_total_amount,
    MAX(total_amount) AS max_total_amount,
    AVG(total_amount) AS avg_total_amount,
    COUNT(1) AS number_of_records,
    COUNT(total_amount) AS number_of_records_not_null
FROM
OPENROWSET
(
    BULK 'trip_data_green_parquet/year=2020/month=01/*.parquet',
    FORMAT = 'PARQUET',
    DATA_SOURCE = 'nyc_taxi_data_raw'
) AS [result]
GO

SELECT
    payment_type, count(1) as number_of_records
FROM
OPENROWSET
(
    BULK 'trip_data_green_parquet/year=2020/month=01/*.parquet',
    FORMAT = 'PARQUET',
    DATA_SOURCE = 'nyc_taxi_data_raw'
) AS [result]
GROUP by payment_type
ORDER by payment_type 
GO
