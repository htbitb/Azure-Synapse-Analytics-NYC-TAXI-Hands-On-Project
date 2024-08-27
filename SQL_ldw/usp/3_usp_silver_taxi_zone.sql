USE nyc_taxi_ldw
GO

CREATE OR ALTER PROCEDURE silver.usp_silver_taxi_zone
AS
BEGIN

    IF OBJECT_ID('silver.taxi_zone') IS NOT NULL
        DROP EXTERNAL TABLE silver.taxi_zone

    CREATE EXTERNAL TABLE silver.taxi_zone
        WITH
        (
            DATA_SOURCE = nyc_taxi_src,
            LOCATION = 'silver/taxi_zone',
            FILE_FORMAT = parquet_file_format
        )
    AS
    SELECT * 
    FROM bronze.taxi_zone
END;

CREATE OR ALTER PROCEDURE silver.usp_silver_calendar
AS
BEGIN
    IF OBJECT_ID('silver.calendar') IS NOT NULL
    DROP EXTERNAL TABLE silver.calendar


    CREATE EXTERNAL TABLE silver.calendar
        WITH
        (
            DATA_SOURCE = nyc_taxi_src,
            LOCATION = 'silver/calendar',
            FILE_FORMAT = parquet_file_format
        )
    AS
    SELECT * FROM bronze.calendar
END;

CREATE OR ALTER PROCEDURE silver.usp_silver_trip_type
AS
BEGIN
    IF OBJECT_ID('silver.trip_type') IS NOT NULL
        DROP EXTERNAL TABLE silver.trip_type;

    CREATE EXTERNAL TABLE silver.trip_type
        WITH
        (
            DATA_SOURCE = nyc_taxi_src,
            LOCATION = 'silver/trip_type',
            FILE_FORMAT = parquet_file_format
        )
    AS
    SELECT *
    FROM bronze.trip_type;


END;

CREATE OR ALTER PROCEDURE silver.usp_silver_vendor
AS
BEGIN

    IF OBJECT_ID('silver.vendor') IS NOT NULL
        DROP EXTERNAL TABLE silver.vendor;

    CREATE EXTERNAL TABLE silver.vendor
        WITH
        (
            DATA_SOURCE = nyc_taxi_src,
            LOCATION = 'silver/vendor',
            FILE_FORMAT = parquet_file_format
        )
    AS
    SELECT *
    FROM bronze.vendor;


END;


CREATE OR ALTER PROCEDURE silver.usp_silver_rate_code
AS
BEGIN

    IF OBJECT_ID('silver.rate_code') IS NOT NULL
        DROP EXTERNAL TABLE silver.rate_code;

    CREATE EXTERNAL TABLE silver.rate_code
        WITH
        (
            DATA_SOURCE = nyc_taxi_src,
            LOCATION = 'silver/rate_code',
            FILE_FORMAT = parquet_file_format
        )
    AS
    SELECT rate_code_id, rate_code
    FROM OPENROWSET(
        BULK 'raw/rate_code.json',
        DATA_SOURCE = 'nyc_taxi_src',
        FORMAT = 'CSV',
        FIELDTERMINATOR = '0x0b',
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0b'
    )
    WITH
    (
        jsonDoc NVARCHAR(MAX)
    ) AS rate_code
    CROSS APPLY OPENJSON(jsonDoc)
    WITH(
        rate_code_id TINYINT,
        rate_code VARCHAR(20) 
    );

END;


CREATE OR ALTER PROCEDURE silver.usp_silver_payment
AS
BEGIN
    IF OBJECT_ID('silver.payment') IS NOT NULL
    DROP EXTERNAL TABLE silver.payment

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
END;

