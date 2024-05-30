/*
This script returns a list of indexes with their type 
and the name of the table for which it was created
*/
USE TRAVEL_AGENCY
GO

SELECT
    t.name AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType
FROM
    sys.indexes i
INNER JOIN
    sys.tables t ON t.object_id = i.object_id
WHERE
    i.index_id > 0
ORDER BY
    TableName,
    IndexName;
