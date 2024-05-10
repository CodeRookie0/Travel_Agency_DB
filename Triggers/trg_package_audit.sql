---------------------------------------------------------------
--- TRIGGER DEFINITION
--- trg_package_audit
---------------------------------------------------------------
-- This trigger is designed to audit DELETE operations on the tbl_package table.
--
-- Trigger Events:
-- AFTER DELETE
--
-- Result of the action:
-- Prints 'Action: DELETE' to indicate that a DELETE operation has been performed on the tbl_package table.
---------------------------------------------------------------
USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_package_audit
ON tbl_package
AFTER DELETE
AS
BEGIN
    PRINT 'Action: DELETE';
END;