use nyc_taxi_discovery
GO

SELECT rate_code_id, rate_code
FROM
OPENROWSET(
    BULK 'rate_code.json',
    DATA_SOURCE = 'nyc_taxi_data_raw',
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