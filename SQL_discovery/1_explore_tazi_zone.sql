create DATABASE nyc_taxi_discovery;

ALTER DATABASE nyc_taxi_discovery COLLATE Latin1_General_100_CI_AI_SC_UTF8;
-------
SELECT *
FROM 
OPENROWSET (
    BULK 'abfss://nyc-taxi-data@adlsnyctaxipjt.dfs.core.windows.net/raw/taxi_zone.csv',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
) AS [result]

-- Examine the data types for the columns
EXEC sp_describe_first_result_set N'SELECT TOP 100 *
FROM 
OPENROWSET (
    BULK ''abfss://nyc-taxi-data@adlsnyctaxipjt.dfs.core.windows.net/raw/taxi_zone.csv'',
    FORMAT = ''CSV'',
    PARSER_VERSION = ''2.0'',
    HEADER_ROW = TRUE,
    FIELDTERMINATOR = '','',
    ROWTERMINATOR = ''\n''
) AS [result]'

-- Calculation max lengh of each table
SELECT 
    MAX(LEN(LocationId)) AS len_LocationID,
    MAX(LEN(Borough)) AS len_Borough,
    MAX(LEN(Zone)) AS len_Zone,
    MAX(LEN(service_zone)) AS len_service_zone
FROM 
OPENROWSET (
    BULK 'abfss://nyc-taxi-data@adlsnyctaxipjt.dfs.core.windows.net/raw/taxi_zone.csv',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
) AS [result]

-- Use WITH clause to provide explicit data types
SELECT TOP 100 *
FROM 
OPENROWSET (
    BULK 'abfss://nyc-taxi-data@adlsnyctaxipjt.dfs.core.windows.net/raw/taxi_zone.csv',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
WITH
(
    LocationID SMALLINT,
    Borough VARCHAR(15),
    Zone VARCHAR(50),
    service_zone VARCHAR(15)
) AS [result]
--
SELECT name, collation_name FROM sys.databases;

SELECT TOP 100 *
FROM 
OPENROWSET (
    BULK 'abfss://nyc-taxi-data@adlsnyctaxipjt.dfs.core.windows.net/raw/taxi_zone.csv',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
WITH
(
    LocationID SMALLINT ,
    Borough VARCHAR(15) COLLATE Latin1_General_100_CI_AI_SC_UTF8,
    Zone VARCHAR(50) COLLATE Latin1_General_100_CI_AI_SC_UTF8,
    service_zone VARCHAR(15) COLLATE Latin1_General_100_CI_AI_SC_UTF8
) AS [result]

-- Select only subset if columns
SELECT TOP 100 *
FROM 
OPENROWSET (
    BULK 'abfss://nyc-taxi-data@adlsnyctaxipjt.dfs.core.windows.net/raw/taxi_zone.csv',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
WITH
(
    LocationID SMALLINT,
    Borough VARCHAR(15)
) AS [result]


-- read data from a file without header
SELECT TOP 100 *
FROM 
OPENROWSET (
    BULK 'abfss://nyc-taxi-data@adlsnyctaxipjt.dfs.core.windows.net/raw/taxi_zone.csv',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)
WITH
(
    LocationID SMALLINT,
    Borough VARCHAR(15),
    Zone VARCHAR(50),
    service_zone VARCHAR(15)
) AS [result]

-- create External Data Source 

CREATE EXTERNAL DATA SOURCE nyc_taxi_data_raw
WITH
(
    LOCATION = 'abfss://nyc-taxi-data@adlsnyctaxipjt.dfs.core.windows.net/raw'
)


SELECT *
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

SELECT name, location from sys.external_data_sources;
