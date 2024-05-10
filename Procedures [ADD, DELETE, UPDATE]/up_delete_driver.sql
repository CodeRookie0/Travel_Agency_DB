--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_delete_driver
--------------------------------------------------------------------------------------------------
-- This procedure is used to delete a driver from the database.
--
-- Input Parameters:
-- @driverId: The ID of the driver to be deleted.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_delete_driver @driverId = 123
--
-- Result of the action:
-- The driver has been successfully deleted.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER  PROCEDURE up_delete_driver
    @driverId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @isReferenced BIT;

    IF NOT EXISTS (SELECT 1 FROM tbl_driver WHERE driverId = @driverId)
    BEGIN
        RAISERROR('The driver with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    SELECT @isReferenced = CASE 
                            WHEN EXISTS (SELECT 1 FROM tbl_busroute WHERE driverId = @driverId) THEN 1
                            ELSE 0
                          END;

    IF @isReferenced = 1
    BEGIN
        RAISERROR('The driver is associated with one or more bus routes and cannot be deleted.', 16, 1);
        RETURN;
    END;

    DELETE FROM tbl_driver WHERE driverId = @driverId;

    PRINT 'The driver has been successfully deleted.';
END;
GO