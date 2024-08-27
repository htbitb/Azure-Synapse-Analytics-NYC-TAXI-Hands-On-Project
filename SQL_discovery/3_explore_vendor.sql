use nyc_taxi_discovery
GO

SELECT * 
FROM
OPENROWSET(
    BULK 'vendor_escaped.csv',
    DATA_SOURCE = 'nyc_taxi_data_raw',
    FORMAT = 'CSV',
    HEADER_ROW = TRUE,
    PARSER_VERSION = '2.0',
    ESCAPECHAR = '\\'
) As ven
GO

EXEC sp_describe_first_result_set N'SELECT * 
FROM
OPENROWSET(
    BULK ''vendor_escaped.csv'',
    DATA_SOURCE = ''nyc_taxi_data_raw'',
    FORMAT = ''CSV'',
    HEADER_ROW = TRUE,
    PARSER_VERSION = ''2.0'',
    ESCAPECHAR = ''\\''
) As ven'