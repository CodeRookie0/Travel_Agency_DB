/*
This SQL query returns the names of all stored procedures (and their details) 
contained in the 'dbo' schema in the database.
*/
USE TRAVEL_AGENCY
GO

SELECT name, object_id, schema_id, type, create_date 
FROM sys.procedures WHERE type_desc = 'SQL_STORED_PROCEDURE';
