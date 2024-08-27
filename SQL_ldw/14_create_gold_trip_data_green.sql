-- USE nyc_taxi_ldw
-- GO

-- SELECT TOP(100)
-- td.year,
-- td.month,
-- tz.borough,
-- convert(DATE, td.lpep_pickup_datetime) as trip_date,
-- cal.day_name AS trip_day,
-- CASE WHEN cal.day_name IN ('Saturday', 'Sunday') THEN 'Y' ELSE 'N' END AS truip_day_weekend_ind
-- FROM silver.vw_trip_data_green td 
-- JOIN silver.taxi_zone tz
--     ON td.pu_location_id = tz.location_id
-- JOIN silver.calendar cal 
--     ON cal.date = CONVERT(DATE, td.lpep_pickup_datetime)
-- WHERE td.year = '2020' and td.month = '01'
-- GO

-- SELECT lpep_pickup_datetime from silver.vw_trip_data_green
-- WHERE year = '2020'

EXEC gold.usp_gold_trip_data_green '2020', '01';
EXEC gold.usp_gold_trip_data_green '2020', '02';
EXEC gold.usp_gold_trip_data_green '2020', '03';
EXEC gold.usp_gold_trip_data_green '2020', '04';
EXEC gold.usp_gold_trip_data_green '2020', '05';
EXEC gold.usp_gold_trip_data_green '2020', '06';
EXEC gold.usp_gold_trip_data_green '2020', '07';
EXEC gold.usp_gold_trip_data_green '2020', '08';
EXEC gold.usp_gold_trip_data_green '2020', '09';
EXEC gold.usp_gold_trip_data_green '2020', '10';
EXEC gold.usp_gold_trip_data_green '2020', '11';
EXEC gold.usp_gold_trip_data_green '2020', '12';
EXEC gold.usp_gold_trip_data_green '2021', '01';
EXEC gold.usp_gold_trip_data_green '2021', '02';
EXEC gold.usp_gold_trip_data_green '2021', '03';
EXEC gold.usp_gold_trip_data_green '2021', '04';
EXEC gold.usp_gold_trip_data_green '2021', '05';
EXEC gold.usp_gold_trip_data_green '2021', '06';