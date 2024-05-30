--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_delete_old_packages
--------------------------------------------------------------------------------------------------
-- This procedure is designed to delete old travel packages from the database.
-- Travel packages with start dates earlier than the current date will be removed.
--
-- Example Usage:
-- EXEC up_delete_old_packages
--
-- Result of the action:
-- Old travel packages with start dates before the current date were successfully deleted.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_delete_old_packages
AS
BEGIN
    DELETE FROM tbl_package
	WHERE packStartDate < GETDATE();
END
GO