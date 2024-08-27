use nyc_taxi_discovery
GO

--select data from a folder
SELECT * 
FROM
OPENROWSET(
    BULK 'trip_data_green_csv/year=2020/month=01/*',
    DATA_SOURCE = 'nyc_taxi_data_raw',
    FORMAT = 'CSV',
    HEADER_ROW = TRUE,
    PARSER_VERSION = '2.0'
) As [result]
GO

-- select data from sub folder
SELECT * 
FROM
OPENROWSET(
    BULK ('trip_data_green_csv/year=2020/month=01/*.csv', 'trip_data_green_csv/year=2020/month=03/*.csv'),
    DATA_SOURCE = 'nyc_taxi_data_raw',
    FORMAT = 'CSV',
    HEADER_ROW = TRUE,
    PARSER_VERSION = '2.0'
) As [result]
GO

-- limited data using filename()
SELECT result.filename() AS file_name,
    result.filepath() AS file_path,
    COUNT(1) as record_count
FROM
OPENROWSET(
    BULK ('trip_data_green_csv/year=*/month=*/*.csv'),
    DATA_SOURCE = 'nyc_taxi_data_raw',
    FORMAT = 'CSV',
    HEADER_ROW = TRUE,
    PARSER_VERSION = '2.0'
) As [result]
WHERE result.filename() IN ('green_tripdata_2020-01.csv', 'green_tripdata_2021-01.csv')
GROUP BY result.filename(), result.filepath()
ORDER BY result.filename(), result.filepath()
GO