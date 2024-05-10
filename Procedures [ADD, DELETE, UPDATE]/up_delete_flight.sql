--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_delete_flight
--------------------------------------------------------------------------------------------------
-- This procedure is used to delete a flight from the database.
--
-- Input Parameters:
-- @fliId: The ID of the flight to be deleted.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_delete_flight @fliId = 1
--
-- Result of the action:
-- The flight has been successfully deleted.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER  PROCEDURE up_delete_flight
    @fliId INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM tbl_flight WHERE fliId = @fliId)
    BEGIN
        RAISERROR('Flight with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

	IF EXISTS (SELECT 1 FROM tbl_package WHERE packOutboundFlightId = @fliId OR packReturnFlightId = @fliId)
    BEGIN
        RAISERROR('The flight is associated with one or more packages and cannot be deleted.', 16, 1);
        RETURN;
    END;

    DELETE FROM tbl_flight WHERE fliId = @fliId;
    PRINT 'The flight has been successfully deleted.';
END;
GO