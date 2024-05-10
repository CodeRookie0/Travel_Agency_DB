--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_add_driver
--------------------------------------------------------------------------------------------------
-- This procedure is used to add a new driver to the database.
--
-- Input Parameters:
-- @driverName: The name of the driver.
-- @driverSurname: The surname of the driver.
-- @driverPhone: The phone number of the driver.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_add_driver @driverName = 'John', @driverSurname = 'Doe', @driverPhone = '123456789'
--
-- Result of the action:
-- The driver has been successfully added.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER  PROCEDURE up_add_driver
    @driverName VARCHAR(50),
    @driverSurname VARCHAR(50),
    @driverPhone VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

	IF @driverName IS NULL OR @driverSurname IS NULL OR @driverPhone IS NULL
    BEGIN
        RAISERROR('Name, surname, and phone must be provided.', 16, 1);
        RETURN;
    END;

    INSERT INTO tbl_driver(driverName, driverSurName, driverPhone)
    VALUES (@driverName, @driverSurname, @driverPhone);
    PRINT 'The driver has been successfully added.';
END;
GO