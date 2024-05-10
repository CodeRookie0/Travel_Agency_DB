--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_add_busRoute
--------------------------------------------------------------------------------------------------
-- This procedure is used to add a new bus route to the database.
--
-- Input Parameters:
-- @driverId: The ID of the driver for the bus route (required).
-- @busRouteStartCity: The ID of the start city for the bus route (required).
-- @busRouteEndCity: The ID of the end city for the bus route (required).
-- @busRouteStartTime: The start time of the bus route (required).
-- @busRouteEndTime: The end time of the bus route (required).
-- @busRouteBusID: The ID of the bus for the route (required).
-- @busRoutePrice: The price of the bus route (required).
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_add_busRoute @driverId = 1, @busRouteStartCity = 2, @busRouteEndCity = 3, @busRouteStartTime = '2024-03-25 08:00:00', @busRouteEndTime = '2024-03-25 18:00:00', @busRouteBusID = 4, @busRoutePrice = 50.00
--
-- Result of the action:
-- The bus route has been successfully added.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER  PROCEDURE up_add_busRoute
    @driverId INT,
    @busRouteStartCity INT,
    @busRouteEndCity INT,
    @busRouteStartTime DATETIME,
    @busRouteEndTime DATETIME,
    @busRouteBusID INT,
	@busRoutePrice FLOAT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM tbl_driver WHERE driverId = @driverId)
    BEGIN
        RAISERROR('The driver with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @busRouteStartCity)
    BEGIN
        RAISERROR('The start city with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @busRouteEndCity)
    BEGIN
        RAISERROR('The end city with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM tbl_bus WHERE busId = @busRouteBusID)
    BEGIN
        RAISERROR('The bus with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    IF @busRoutePrice <= 0
    BEGIN
        RAISERROR('The route price must be greater than zero.', 16, 1);
        RETURN;
    END;

    IF DATEDIFF(DAY, @busRouteStartTime, @busRouteEndTime) > 3
    BEGIN
        RAISERROR('The difference between start time and end time cannot exceed 3 days.', 16, 1);
        RETURN;
    END;

    IF @busRouteStartTime IS NULL OR @busRouteEndTime IS NULL
    BEGIN
        RAISERROR('All parameters must be provided.', 16, 1);
        RETURN;
    END;

    INSERT INTO tbl_busroute(driverId, busRouteStartCityId, busRouteEndCityId, busRouteStartTime, busRouteEndTime, busRouteBusID, busRoutePrice)
    VALUES (@driverId, @busRouteStartCity, @busRouteEndCity, @busRouteStartTime, @busRouteEndTime, @busRouteBusID, @busRoutePrice);
	PRINT 'The bus route has been successfully added.';
END;
GO