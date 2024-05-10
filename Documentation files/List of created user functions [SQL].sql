-- This SQL query returns a list of user functions (and their details) in the database

SELECT 
    ROUTINE_NAME,
    ROUTINE_TYPE,
    DATA_TYPE,
    CREATED,
    LAST_ALTERED
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'FUNCTION';
