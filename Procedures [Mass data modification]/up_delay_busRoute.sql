--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_delay_busRoute
--------------------------------------------------------------------------------------------------
-- This procedure is used to delay the start and end times of bus routes in the database.
-- The procedure updates the start and end times of bus routes based on the provided parameters.
--
-- Input Parameters:
-- @startCityId: The ID of the start city of bus routes to be delayed (optional).
-- @endCityId: The ID of the end city of bus routes to be delayed (optional).
-- @delayInHours: The number of hours by which the bus routes should be delayed (required).
-- @startDateFilter: The start date filter for bus routes to be delayed (optional).
-- @endDateFilter: The end date filter for bus routes to be delayed (optional).
-- @startTimeOfDayFilter: The start time of day filter for bus routes to be delayed (optional).
-- @endTimeOfDayFilter: The end time of day filter for bus routes to be delayed (optional).
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_delay_busRoute @delayInHours = 2;
--
-- Result of the action:
-- The start and end times of bus routes have been successfully delayed.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_delay_busRoute
    @startCityId INT = NULL,
    @endCityId INT = NULL,
    @delayInHours INT,
    @startDateFilter DATETIME = NULL,
    @endDateFilter DATETIME = NULL,
    @startTimeOfDayFilter TIME = NULL,
    @endTimeOfDayFilter TIME = NULL
AS
BEGIN
    UPDATE tbl_busroute
    SET busRouteStartTime = DATEADD(HOUR, @delayInHours, busRouteStartTime),
        busRouteEndTime = DATEADD(HOUR, @delayInHours, busRouteEndTime)
    WHERE (@startCityId IS NULL OR busRouteStartCityId = @startCityId)
        AND (@endCityId IS NULL OR busRouteEndCityId = @endCityId)
        AND (@startDateFilter IS NULL OR CONVERT(DATE, busRouteStartTime) >= @startDateFilter)
        AND (@endDateFilter IS NULL OR CONVERT(DATE, busRouteEndTime) <= @endDateFilter)
        AND (@startTimeOfDayFilter IS NULL OR CAST(busRouteStartTime AS TIME) >= @startTimeOfDayFilter)
        AND (@endTimeOfDayFilter IS NULL OR CAST(busRouteEndTime AS TIME) <= @endTimeOfDayFilter);
END;