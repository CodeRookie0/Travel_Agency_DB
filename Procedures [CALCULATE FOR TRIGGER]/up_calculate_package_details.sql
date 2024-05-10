--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_calculate_package_details
--------------------------------------------------------------------------------------------------
-- This procedure calculates and updates the details of a package.
-- It calculates the start date, end date, duration, and price of the package and
-- updates the corresponding fields in the tbl_package table. 
--
-- This procedure is triggered when inserting or modifying a record in the tbl_package table.
-- 
--
-- Input Parameters:
-- @packId: The ID of the package for which details need to be calculated and updated (required).
-- @packHotId: The ID of the hotel associated with the package (required).
-- @packOutboundFlightId: The ID of the outbound flight associated with the package (optional).
-- @packReturnFlightId: The ID of the return flight associated with the package (optional).
-- @packOutboundBusRouteId: The ID of the outbound bus route associated with the package (optional).
-- @packReturnBusRouteId: The ID of the return bus route associated with the package (optional).
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_calculate_package_details @packId = 1, @packHotId = 101, @packOutboundFlightId = 201,
--     @packReturnFlightId = 202, @packOutboundBusRouteId = 301, @packReturnBusRouteId = 302;
--
-- Result of the action:
-- The details of the specified package have been successfully calculated and updated.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_calculate_package_details 
    @packId INT,
    @packHotId INT,
    @packOutboundFlightId INT,
    @packReturnFlightId INT,
    @packOutboundBusRouteId INT,
    @packReturnBusRouteId INT
AS
BEGIN
    DECLARE @packStartDate DATE
    DECLARE @packEndDate DATE
    DECLARE @packDuration TINYINT
    DECLARE @packPrice FLOAT

    IF @packOutboundFlightId IS NOT NULL
        SELECT @packStartDate = fliEndTime FROM tbl_flight WHERE fliId = @packOutboundFlightId
    ELSE IF @packOutboundBusRouteId IS NOT NULL
        SELECT @packStartDate = busRouteEndTime FROM tbl_busroute WHERE busRouteId = @packOutboundBusRouteId

    IF @packReturnFlightId IS NOT NULL
        SELECT @packEndDate = fliStartTime FROM tbl_flight WHERE fliId = @packReturnFlightId
    ELSE IF @packReturnBusRouteId IS NOT NULL
        SELECT @packEndDate = busRouteStartTime FROM tbl_busroute WHERE busRouteId = @packReturnBusRouteId

    SELECT @packDuration = DATEDIFF(DAY, @packStartDate, @packEndDate) + 1

    SELECT @packPrice = 
        (
            (SELECT hotPricePerNight FROM tbl_hotel WHERE hotId = @packHotId) * @packDuration +
            ISNULL((SELECT fliPrice FROM tbl_flight WHERE fliId = @packOutboundFlightId), 0) +
            ISNULL((SELECT fliPrice FROM tbl_flight WHERE fliId = @packReturnFlightId), 0) +
            ISNULL((SELECT busRoutePrice FROM tbl_busroute WHERE busRouteId = @packOutboundBusRouteId), 0) +
            ISNULL((SELECT busRoutePrice FROM tbl_busroute WHERE busRouteId = @packReturnBusRouteId), 0)
        ) * 1.15

    UPDATE tbl_package 
    SET packStartDate = @packStartDate,
        packEndDate = @packEndDate,
        packDuration = @packDuration,
        packPrice = @packPrice
    WHERE packId = @packId
END