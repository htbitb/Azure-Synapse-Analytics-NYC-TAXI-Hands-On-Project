USE nyc_taxi_ldw
GO

IF OBJECT_ID('silver.rate_code') IS NOT NULL
    DROP EXTERNAL TABLE silver.rate_code
GO

CREATE EXTERNAL TABLE silver.rate_code
    WITH
    (
        DATA_SOURCE = nyc_taxi_src,
        LOCATION = 'silver/rate_code',
        FILE_FORMAT = parquet_file_format
    )
AS
SELECT rate_code_id, rate_code
FROM
OPENROWSET(
    BULK 'raw/rate_code.json',
    DATA_SOURCE = 'nyc_taxi_src',
    FORMAT = 'csv',
    FIELDTERMINATOR = '0x0b',
    FIELDQUOTE = '0x0b',
    ROWTERMINATOR = '0x0b'
) 
WITH
(
    jsonDoc NVARCHAR(MAX)
)As rate_code
CROSS APPLY OPENJSON(jsonDoc)
WITH
(
    rate_code_id TINYINT,
    rate_code VARCHAR(20)
)
GO

SELECT * FROM silver.rate_code;