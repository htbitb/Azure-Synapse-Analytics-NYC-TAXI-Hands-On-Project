use nyc_taxi_discovery

-- Select file from source
SELECT * 
FROM
OPENROWSET(
    BULK 'calendar.csv',
    DATA_SOURCE = 'nyc_taxi_data_raw',
    FORMAT = 'CSV',
    HEADER_ROW = TRUE,
    PARSER_VERSION = '2.0'
) AS [result]

-- Examine the data types for the columns
EXEC sp_describe_first_result_set N'SELECT * 
FROM
OPENROWSET(
    BULK ''abfss://nyc-taxi-data@adlsnyctaxipjt.dfs.core.windows.net/raw/calendar.csv'',
    FORMAT = ''CSV'',
    HEADER_ROW = TRUE,
    PARSER_VERSION = ''2.0''
) AS [result]'

-- Calculation max lengh of each table
SELECT * 
FROM
OPENROWSET(
    BULK 'calendar.csv',
    DATA_SOURCE = 'nyc_taxi_data_raw',
    FORMAT = 'CSV',
    HEADER_ROW = TRUE,
    PARSER_VERSION = '2.0'
) 
WITH
(
    date_key int,
    date    date,
    year    SMALLINT,
    month   TINYINT,
    day     TINYINT,
    day_name VARCHAR(10),
    day_of_year SMALLINT,
    week_of_month TINYINT,
    week_of_year TINYINT,
    month_name VARCHAR(10),
    year_month int,
    year_week int
)AS [result]