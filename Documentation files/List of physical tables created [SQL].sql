--This query returns a list of all tables in the "dbo" schema.

USE TRAVEL_AGENCY;
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';


