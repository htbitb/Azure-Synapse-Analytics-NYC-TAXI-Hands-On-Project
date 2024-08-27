USE nyc_taxi_discovery
GO

-- Check for duplicates in the taxi zone
SELECT 
    Borough,
    COUNT(1) AS number_of_records
FROM
    OPENROWSET (
        BULK 'taxi_zone.csv',
        DATA_SOURCE = 'nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        FIRST_ROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    )
    WITH
    (
        LocationID SMALLINT 1,
        Borough VARCHAR(15) 2,
        Zone VARCHAR(50) 3,
        service_zone VARCHAR(15) 4
    ) AS [result]
GROUP BY Borough
HAVING COUNT(1) > 1
