USE nyc_taxi_ldw
GO

IF OBJECT_ID('silver.payment') IS NOT NULL
    DROP EXTERNAL TABLE silver.payment
GO

CREATE EXTERNAL TABLE silver.payment
    WITH
    (
        DATA_SOURCE = nyc_taxi_src,
        LOCATION = 'silver/payment',
        FILE_FORMAT = parquet_file_format
    )
AS
SELECT payment_type, description
FROM
OPENROWSET(
    BULK 'raw/payment_type.json',
    DATA_SOURCE = 'nyc_taxi_src',
    FORMAT = 'csv',
    FIELDTERMINATOR = '0x0b',
    FIELDQUOTE = '0x0b'
) 
WITH
(
    jsonDoc NVARCHAR(MAX)
)As payment
CROSS APPLY OPENJSON(jsonDoc)
WITH
(
    payment_type SMALLINT,
    description VARCHAR(20) '$.payment_type_desc'
)
GO

SELECT * FROM silver.payment;