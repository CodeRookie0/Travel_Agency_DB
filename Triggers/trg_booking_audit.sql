---------------------------------------------------------------
--- TRIGGER DEFINITION
--- trg_booking_audit
---------------------------------------------------------------
-- This trigger is designed to audit DELETE operations on the tbl_booking table.
--
-- Trigger Events:
-- AFTER DELETE
--
-- Example Usage:
-- No direct usage. This trigger automatically executes after DELETE operations on the tbl_booking table.
--
-- Result of the action:
-- Prints 'Action: DELETE' to indicate that a DELETE operation has been performed on the tbl_booking table.
---------------------------------------------------------------
USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_booking_audit
ON tbl_booking
AFTER DELETE
AS
BEGIN
    PRINT 'Action: DELETE';
END;