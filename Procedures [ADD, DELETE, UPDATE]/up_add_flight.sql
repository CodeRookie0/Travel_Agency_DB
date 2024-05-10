--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_add_flight
--------------------------------------------------------------------------------------------------
-- This procedure is used to add a new flight to the database.
--
-- Input Parameters:
-- @fliStartCityId: The ID of the city where the flight starts.
-- @fliEndCityId: The ID of the city where the flight ends.
-- @fliStartTime: The start time of the flight.
-- @fliEndTime: The end time of the flight.
-- @fliClass: The class of the flight (First, Business, or Economy).
-- @fliPrice: The price of the flight.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_add_flight @fliStartCityId = 1, @fliEndCityId = 2, @fliStartTime = '2024-03-25 08:00:00', @fliEndTime = '2024-03-25 10:00:00', @fliClass = 'Economy', @fliPrice = 500.00
--
-- Result of the action:
-- The flight was successfully added.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER  PROCEDURE up_add_flight
    @fliStartCityId INT,
    @fliEndCityId INT,
    @fliStartTime DATETIME,
    @fliEndTime DATETIME,
    @fliClass VARCHAR(10),
    @fliPrice FLOAT
AS
BEGIN
    SET NOCOUNT ON;

	IF @fliStartTime IS NULL OR @fliEndTime IS NULL OR @fliClass = '' OR @fliPrice IS NULL
    BEGIN
        RAISERROR('One or more required fields are empty.', 16, 1);
        RETURN;
    END;

	IF NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @fliStartCityId)
    BEGIN
        RAISERROR('Start city with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @fliEndCityId)
    BEGIN
        RAISERROR('End city with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

	IF @fliClass NOT IN ('First', 'Business', 'Economy')
    BEGIN
        RAISERROR('Invalid flight class. Class must be First, Business, or Economy.', 16, 1);
        RETURN;
    END;

    IF @fliPrice <= 0
    BEGIN
        RAISERROR('Flight price must be greater than zero.', 16, 1);
        RETURN;
    END;

	DECLARE @timeDifference INT;

    SET @timeDifference = DATEDIFF(HOUR, @fliStartTime, @fliEndTime);
    IF @timeDifference > 19 OR @timeDifference < 1
    BEGIN
        RAISERROR('Time difference between start and end cannot exceed 19 hours and be less than 1 hour.', 16, 1);
        RETURN;
    END;

    INSERT INTO tbl_flight(fliStartCityId, fliEndCityId, fliStartTime, fliEndTime, fliClass, fliPrice)
    VALUES (@fliStartCityId, @fliEndCityId, @fliStartTime, @fliEndTime, @fliClass, @fliPrice);
    PRINT 'The flight was successfully added.';
END;
GO