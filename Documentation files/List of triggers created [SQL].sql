/*
This SQL query returns the names of the triggers and 
the names of the tables to which they are assigned
*/

SELECT
    name AS TriggerName,
    OBJECT_NAME(parent_id) AS TableName
FROM sys.triggers
ORDER BY TableName, TriggerName;
