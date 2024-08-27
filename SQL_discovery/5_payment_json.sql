use nyc_taxi_discovery
GO

SELECT CAST(JSON_VALUE(jsonDoc, '$.payment_type') AS SMALLINT) payment_type,
CAST(JSON_VALUE(jsonDoc, '$.payment_type_desc') AS VARCHAR(15)) payment_type_desc
FROM
OPENROWSET(
    BULK 'payment_type.json',
    DATA_SOURCE = 'nyc_taxi_data_raw',
    FORMAT = 'csv',
    FIELDTERMINATOR = '0x0b',
    FIELDQUOTE = '0x0b',
    ROWTERMINATOR = '0x0a'
) 
WITH
(
    jsonDoc NVARCHAR(MAX)
)As payment
GO

-- retrive data using json function
SELECT payment_type, description
FROM
OPENROWSET(
    BULK 'payment_type.json',
    DATA_SOURCE = 'nyc_taxi_data_raw',
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

------------------------------------------------------------------
-- Reading data from JSON with arrays
------------------------------------------------------------------
SELECT CAST(JSON_VALUE(jsonDoc, '$.payment_type') AS SMALLINT) payment_type,
        CAST(JSON_VALUE(jsonDoc, '$.payment_type_desc[0].value') AS VARCHAR(15)) payment_type_desc_0,
        CAST(JSON_VALUE(jsonDoc, '$.payment_type_desc[1].value') AS VARCHAR(15)) payment_type_desc_1
FROM
OPENROWSET(
    BULK 'payment_type_array.json',
    DATA_SOURCE = 'nyc_taxi_data_raw',
    FORMAT = 'csv',
    FIELDTERMINATOR = '0x0b',
    FIELDQUOTE = '0x0b',
    ROWTERMINATOR = '0x0a'
) 
WITH
(
    jsonDoc NVARCHAR(MAX)
)As payment
GO

-- Use openjson
SELECT payment_type, payment_type_desc_value
FROM
OPENROWSET(
    BULK 'payment_type_array.json',
    DATA_SOURCE = 'nyc_taxi_data_raw',
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
    payment_type_desc NVARCHAR(MAX) AS JSON
)
CROSS APPLY OPENJSON(payment_type_desc)
WITH
(
    sub_type SMALLINT,
    payment_type_desc_value VARCHAR(20) '$.value'
)
GO

























