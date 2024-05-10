--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_update_busRoute
--------------------------------------------------------------------------------------------------
-- This procedure is used to update the details of a bus route in the database.
-- If the bus route is associated with one or more packages and the start city or end city is being updated, an error is raised.
--
-- Input Parameters:
-- @busRouteId: The ID of the bus route to be updated (required).
-- @driverId: The ID of the driver assigned to the bus route (optional).
-- @busRouteStartCity: The ID of the start city for the bus route (optional).
-- @busRouteEndCity: The ID of the end city for the bus route (optional).
-- @busRouteStartTime: The start time of the bus route (optional).
-- @busRouteEndTime: The end time of the bus route (optional).
-- @busRouteBusID: The ID of the bus assigned to the bus route (optional).
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_update_busRoute @busRouteId = 1, @driverId = 2, @busRouteStartTime = '2024-04-01 08:00:00', @busRouteEndTime = '2024-04-01 16:00:00';
--
-- Result of the action:
-- The details of the bus route have been successfully updated.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_update_busRoute
    @busRouteId INT,
    @driverId INT = NULL,
    @busRouteStartCity INT = NULL,
    @busRouteEndCity INT = NULL,
    @busRouteStartTime DATETIME = NULL,
    @busRouteEndTime DATETIME = NULL,
    @busRouteBusID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM  tbl_busroute WHERE busRouteId = @busRouteId)
    BEGIN
        RAISERROR('The bus route with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    IF @driverId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbl_driver WHERE driverId = @driverId)
    BEGIN
        RAISERROR('The driver with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    IF @busRouteBusID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbl_bus WHERE busId = @busRouteBusID)
    BEGIN
        RAISERROR('The bus with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

	DECLARE @timeDifference INT;

	IF @busRouteStartTime IS NOT NULL OR @busRouteEndTime IS NOT NULL
    BEGIN
        DECLARE @currentStartTime DATETIME;
        DECLARE @currentEndTime DATETIME;

        SELECT @currentStartTime = busRouteStartTime, @currentEndTime = busRouteEndTime FROM  tbl_busroute WHERE busRouteId = @busRouteId;

        SET @busRouteStartTime = COALESCE(@busRouteStartTime, @currentStartTime);
        SET @busRouteEndTime = COALESCE(@busRouteEndTime, @currentEndTime);

        SET @timeDifference = DATEDIFF(DAY, @busRouteStartTime, @busRouteEndTime);

        IF @timeDifference > 3
        BEGIN
            RAISERROR('The difference between start time and end time cannot exceed 3 days.', 16, 1);
            RETURN;
        END;
    END;

	IF @busRouteStartCity IS NULL AND @busRouteEndCity IS NULL
    BEGIN
        UPDATE  tbl_busroute
		SET 
			driverId = COALESCE(@driverId, driverId),
			busRouteStartTime = COALESCE(@busRouteStartTime, busRouteStartTime),
			busRouteEndTime = COALESCE(@busRouteEndTime, busRouteEndTime),
			busRouteBusID = COALESCE(@busRouteBusID, busRouteBusID)
		WHERE busRouteId = @busRouteId;
    END
    ELSE
    BEGIN
		DECLARE @packageOutboundCount INT;
		SELECT @packageOutboundCount = COUNT(*)
		FROM tbl_package
		WHERE packOutboundBusRouteId = @busRouteId;

		DECLARE @packageReturnCount INT;
		SELECT @packageReturnCount = COUNT(*)
		FROM tbl_package
		WHERE packOutboundBusRouteId = @busRouteId;

		IF @packageOutboundCount > 0 AND @busRouteEndCity IS NOT NULL
		BEGIN
			RAISERROR('The bus route is associated with one or more packages and cannot have its end city changed.', 16, 1);
			RETURN;
		END
		ELSE IF @packageReturnCount > 0 AND @busRouteStartCity IS NOT NULL
		BEGIN
			RAISERROR('The bus route is associated with one or more packages and cannot have its start city changed.', 16, 1);
			RETURN;
		END
		ELSE
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @busRouteStartCity) OR NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @busRouteEndCity)
			BEGIN
				RAISERROR('One or both of the provided city IDs do not exist.', 16, 1);
				RETURN;
			END;

			UPDATE  tbl_busroute
			SET 
				driverId = COALESCE(@driverId, driverId),
				busRouteStartCityId = COALESCE(@busRouteStartCity, busRouteStartCityId),
				busRouteEndCityId = COALESCE(@busRouteEndCity, busRouteEndCityId),
				busRouteStartTime = COALESCE(@busRouteStartTime, busRouteStartTime),
				busRouteEndTime = COALESCE(@busRouteEndTime, busRouteEndTime),
				busRouteBusID = COALESCE(@busRouteBusID, busRouteBusID)
			WHERE busRouteId = @busRouteId;
		END;
    END;
END;
GO