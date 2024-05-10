/* 
This query returns table names, column names, default constraint 
names, and default expressions for columns in the database.
*/

SELECT
    OBJECT_NAME(dc.parent_object_id) AS TableName,
    c.name AS ColumnName,
    dc.name AS DefaultObjectName,
    dc.definition AS DefaultExpression
FROM sys.default_constraints dc
INNER JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id;
