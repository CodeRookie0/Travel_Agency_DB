--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_update_driver
--------------------------------------------------------------------------------------------------
-- This procedure is used to update the details of a driver in the database.
--
-- Input Parameters:
-- @driverId: The ID of the driver to be updated.
-- @driverName: (Optional) The new name of the driver.
-- @driverSurname: (Optional) The new surname of the driver.
-- @driverPhone: (Optional) The new phone number of the driver.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_update_driver @driverId = 123, @driverName = 'John', @driverSurname = 'Doe', @driverPhone = '123456789'
--
-- Result of the action:
-- Driver details have been successfully changed.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER  PROCEDURE up_update_driver
    @driverId INT,
    @driverName VARCHAR(50) = NULL,
    @driverSurname VARCHAR(50) = NULL,
    @driverPhone VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

	IF NOT EXISTS (SELECT 1 FROM tbl_driver WHERE driverId = @driverId)
    BEGIN
        RAISERROR('The driver with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    UPDATE tbl_driver
    SET 
        driverName = COALESCE(@driverName, driverName),
        driverSurname = COALESCE(@driverSurname, driverSurname),
        driverPhone = COALESCE(@driverPhone, driverPhone)
    WHERE driverId = @driverId;
	PRINT 'Driver details have been successfully changed.';
END;
GO