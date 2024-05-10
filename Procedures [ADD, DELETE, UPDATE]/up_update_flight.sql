--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_update_flight
--------------------------------------------------------------------------------------------------
-- This procedure is used to update flight information in the database.
-- The procedure checks if the flight ID exists and if the provided data is valid before performing the update.
-- If the flight is associated with packages, certain fields cannot be updated to maintain data consistency.
--
-- Input Parameters:
-- @fliId: The ID of the flight to be updated.
-- @fliStartCityId: (Optional) The ID of the start city for the flight.
-- @fliEndCityId: (Optional) The ID of the end city for the flight.
-- @fliStartTime: (Optional) The departure time of the flight.
-- @fliEndTime: (Optional) The arrival time of the flight.
-- @fliClass: (Optional) The class of the flight (First, Business, Economy).
-- @fliPrice: (Optional) The price of the flight.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_update_flight @fliId = 1, @fliPrice = 500.00
--
-- Result of the action:
-- Flight data was changed successfully.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER  PROCEDURE up_update_flight
    @fliId INT,
    @fliStartCityId INT = NULL,
    @fliEndCityId INT = NULL,
    @fliStartTime DATETIME = NULL,
    @fliEndTime DATETIME = NULL,
    @fliClass VARCHAR(10) = NULL,
    @fliPrice FLOAT = NULL
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @packageOutboundCount INT;
	DECLARE @packageReturnCount INT;

    IF NOT EXISTS (SELECT 1 FROM tbl_flight WHERE fliId = @fliId)
    BEGIN
        RAISERROR('The flight with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

	IF @fliClass IS NOT NULL AND @fliClass NOT IN ('First', 'Business', 'Economy')
    BEGIN
        RAISERROR('Invalid flight class. Class must be First, Business, or Economy.', 16, 1);
        RETURN;
    END;

	IF @fliPrice IS NOT NULL AND @fliPrice <= 0
    BEGIN
        RAISERROR('Flight price must be greater than zero.', 16, 1);
		RETURN;
    END;

	DECLARE @timeDifference INT;

    IF @fliStartTime IS NOT NULL OR @fliEndTime IS NOT NULL
    BEGIN
        DECLARE @currentStartTime DATETIME;
        DECLARE @currentEndTime DATETIME;

        SELECT @currentStartTime = fliStartTime, @currentEndTime = fliEndTime FROM tbl_flight WHERE fliId = @fliId;

        SET @fliStartTime = COALESCE(@fliStartTime, @currentStartTime);
        SET @fliEndTime = COALESCE(@fliEndTime, @currentEndTime);

        SET @timeDifference = DATEDIFF(HOUR, @fliStartTime, @fliEndTime);

        IF @timeDifference > 19 OR @timeDifference < 1
        BEGIN
            RAISERROR('Time difference between start and end cannot exceed 19 hours and be less than 1 hour.', 16, 1);
            RETURN;
        END;
    END;

    IF @fliStartCityId IS NULL AND @fliEndCityId IS NULL
    BEGIN
        UPDATE tbl_flight
        SET 
            fliStartTime = COALESCE(@fliStartTime, fliStartTime),
            fliEndTime = COALESCE(@fliEndTime, fliEndTime),
            fliClass = COALESCE(@fliClass, fliClass),
            fliPrice = COALESCE(@fliPrice, fliPrice)
        WHERE fliId = @fliId;
    END
    ELSE
    BEGIN
		SELECT @packageOutboundCount = COUNT(*)
		FROM tbl_package
		WHERE packOutboundFlightId = @fliId;

		SELECT @packageReturnCount = COUNT(*)
		FROM tbl_package
		WHERE packReturnFlightId = @fliId;

		IF @packageOutboundCount > 0 AND @fliEndCityId IS NOT NULL
		BEGIN
			RAISERROR('The flight is associated with one or more packages and cannot have its end city changed.', 16, 1);
			RETURN;
		END
		ELSE IF @packageReturnCount > 0 AND @fliStartCityId IS NOT NULL
		BEGIN
			RAISERROR('The flight is associated with one or more packages and cannot have its start city changed.', 16, 1);
			RETURN;
		END
		ELSE
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @fliStartCityId) OR NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @fliEndCityId)
			BEGIN
				RAISERROR('One or both of the provided city IDs do not exist.', 16, 1);
				RETURN;
			END;

			UPDATE tbl_flight
			SET 
				fliStartCityId = COALESCE(@fliStartCityId, fliStartCityId),
				fliEndCityId = COALESCE(@fliEndCityId, fliEndCityId),
				fliStartTime = COALESCE(@fliStartTime, fliStartTime),
				fliEndTime = COALESCE(@fliEndTime, fliEndTime),
				fliClass = COALESCE(@fliClass, fliClass),
				fliPrice = COALESCE(@fliPrice, fliPrice)
			WHERE fliId = @fliId;
		END;
    END;
END;
GO