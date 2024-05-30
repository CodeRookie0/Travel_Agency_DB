--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_delete_old_flights
--------------------------------------------------------------------------------------------------
-- This procedure is used to delete old flights from the database.
-- Flights with end times earlier than the current date will be removed.
--
-- Example Usage:
-- EXEC up_delete_old_flights
--
-- Result of the action:
-- Old flights with end times before the current date were successfully deleted.
--------------------------------------------------------------------------------------------------


USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_delete_old_flights
AS
BEGIN
    DELETE FROM tbl_flight
    WHERE fliEndTime < GETDATE();
END
GO
