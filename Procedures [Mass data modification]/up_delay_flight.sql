--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_delay_flight
--------------------------------------------------------------------------------------------------
-- This procedure is used to delay the start and end times of flights in the database.
-- The procedure updates the start and end times of flights based on the provided parameters.
--
-- Input Parameters:
-- @startCityId: The ID of the start city of flights to be delayed (optional).
-- @endCityId: The ID of the end city of flights to be delayed (optional).
-- @delayInHours: The number of hours by which the flights should be delayed (required).
-- @startDateFilter: The start date filter for flights to be delayed (optional).
-- @endDateFilter: The end date filter for flights to be delayed (optional).
-- @startTimeOfDayFilter: The start time of day filter for flights to be delayed (optional).
-- @endTimeOfDayFilter: The end time of day filter for flights to be delayed (optional).
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_delay_flight @delayInHours = 2;
--
-- Result of the action:
-- The start and end times of flights have been successfully delayed.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_delay_flight
    @startCityId INT = NULL,
    @endCityId INT = NULL,
    @delayInHours INT,
    @startDateFilter DATETIME = NULL,
    @endDateFilter DATETIME = NULL,
    @startTimeOfDayFilter TIME = NULL,
    @endTimeOfDayFilter TIME = NULL
AS
BEGIN
    UPDATE tbl_flight
    SET fliStartTime = DATEADD(HOUR, @delayInHours, fliStartTime),
        fliEndTime = DATEADD(HOUR, @delayInHours, fliEndTime)
    WHERE (@startCityId IS NULL OR fliStartCityId = @startCityId)
        AND (@endCityId IS NULL OR fliEndCityId = @endCityId)
        AND (@startDateFilter IS NULL OR CONVERT(DATE, fliStartTime) >= @startDateFilter)
        AND (@endDateFilter IS NULL OR CONVERT(DATE, fliEndTime) <= @endDateFilter)
        AND (@startTimeOfDayFilter IS NULL OR CAST(fliStartTime AS TIME) >= @startTimeOfDayFilter)
        AND (@endTimeOfDayFilter IS NULL OR CAST(fliEndTime AS TIME) <= @endTimeOfDayFilter);
END;