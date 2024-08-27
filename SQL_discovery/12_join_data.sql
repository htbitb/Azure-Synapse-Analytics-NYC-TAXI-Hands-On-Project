USE nyc_taxi_discovery
GO

-- Identify number of trips made from each borough!
SELECT TOP 100 *
FROM
OPENROWSET
(
    BULK 'trip_data_green_parquet/year=2020/month=01/*.parquet',
    FORMAT = 'PARQUET',
    DATA_SOURCE = 'nyc_taxi_data_raw'
) AS [result]
-- WHERE PuLocationID is NULL
GO


SELECT taxi_zone.Borough, count(1) as number_of_records
    FROM OPENROWSET(
                        BULK 'trip_data_green_parquet/year=2020/month=01/*.parquet',
                        FORMAT = 'PARQUET',
                        DATA_SOURCE = 'nyc_taxi_data_raw'
                    ) AS trip_data
        JOIN 
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
        ) AS taxi_zone
        ON trip_data.PULocationID = taxi_zone.LocationID
        GROUP BY taxi_zone.Borough