USE nyc_taxi_discovery
GO

-- Query parquet format
SELECT TOP 100 *
FROM
OPENROWSET
(
    BULK 'trip_data_green_parquet/year=2020/month=01/',
    FORMAT = 'PARQUET',
    DATA_SOURCE = 'nyc_taxi_data_raw'
) AS [result]
GO

-- Identifu the interred data types
EXEC sp_describe_first_result_set N'SELECT TOP 100 *
FROM
OPENROWSET
(
    BULK ''trip_data_green_parquet/year=2020/month=01/'',
    FORMAT = ''PARQUET'',
    DATA_SOURCE = ''nyc_taxi_data_raw''
) AS [result]'
GO

-- 
SELECT TOP 100 *
FROM
OPENROWSET
(
    BULK 'trip_data_green_parquet/year=2020/month=01/',
    FORMAT = 'PARQUET',
    DATA_SOURCE = 'nyc_taxi_data_raw'
)
WITH
(
      VendorID INT,
        lpep_pickup_datetime datetime2(7),
        lpep_dropoff_datetime datetime2(7),
        store_and_fwd_flag CHAR(1),
        RatecodeID INT,
        PULocationID INT,
        DOLocationID INT,
        passenger_count INT,
        trip_distance FLOAT,
        fare_amount FLOAT,
        extra FLOAT,
        mta_tax FLOAT,
        tip_amount FLOAT,
        tolls_amount FLOAT,
        ehail_fee INT,
        improvement_surcharge FLOAT,
        total_amount FLOAT,
        payment_type INT,
        trip_type INT,
        congestion_surcharge FLOAT
) AS [result]
GO

/*
Assignment
---------
1) Query from folder using wildcard characters
*/
SELECT TOP 100 *
FROM
OPENROWSET
(
    BULK 'trip_data_green_parquet/year=2020/month=01/*.parquet',
    FORMAT = 'PARQUET',
    DATA_SOURCE = 'nyc_taxi_data_raw'
) AS [result]
GO

-- 2) use filename function
SELECT 
    trip_data.filename() as file_name,
    trip_data.*
FROM
OPENROWSET
(
    BULK 'trip_data_green_parquet/year=*/month=*/*.parquet',
    FORMAT = 'PARQUET',
    DATA_SOURCE = 'nyc_taxi_data_raw'
) AS trip_data
GO

-- 3) Query from sub folder
SELECT TOP 100 *
FROM
OPENROWSET
(
    BULK 'trip_data_green_parquet/year=*/month=*/*.parquet',
    FORMAT = 'PARQUET',
    DATA_SOURCE = 'nyc_taxi_data_raw'
) AS [result]
GO

-- 4) Use filepath function to select only certain partitions
SELECT trip_data.filepath(1) AS year,
       trip_data.filepath(2) AS month,
       COUNT(1) AS record_count
  FROM OPENROWSET (
      BULK 'trip_data_green_parquet/year=*/month=*/*.parquet',
      DATA_SOURCE = 'nyc_taxi_data_raw',
      FORMAT = 'PARQUET'
  ) AS trip_data
 WHERE trip_data.filepath(1) = '2020'
   AND trip_data.filepath(2) IN ('06', '07', '08')
GROUP BY trip_data.filepath(1), trip_data.filepath(2)
ORDER BY trip_data.filepath(1), trip_data.filepath(2);