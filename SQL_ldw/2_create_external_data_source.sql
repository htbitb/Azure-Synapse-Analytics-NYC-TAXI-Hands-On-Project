USE nyc_taxi_ldw
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'nyc_taxi_src')
    CREATE EXTERNAL DATA SOURCE nyc_taxi_src
    WITH
    (
        LOCATION = 'https://adlsnyctaxipjt.dfs.core.windows.net/nyc-taxi-data'
    )