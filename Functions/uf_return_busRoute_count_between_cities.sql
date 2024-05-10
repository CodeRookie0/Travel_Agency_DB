---------------------------------------------------------------
--- FUNCTION DEFINITION
--- uf_return_busRoute_count_between_cities
---------------------------------------------------------------
-- This function calculates the number of bus routes available between two specified cities.
--
-- Input Parameters:
-- - @StartCity: The name of the starting city.
-- - @EndCity: The name of the destination city.
--
-- Output Parameters:
-- - @BusRouteCount : The count of bus routes available between the specified start and end cities.
--
-- Example Usage:
-- SELECT dbo.uf_return_busRoute_count_between_cities('Norsup', 'Port Vila');
--
-- Result of the action:
-- Returns the count of bus routes available between the specified start and end cities.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER FUNCTION dbo.uf_return_busRoute_count_between_cities
(
    @StartCity VARCHAR(60),
    @EndCity VARCHAR(60)
)
RETURNS INT
AS
BEGIN
    DECLARE @BusRouteCount INT;

    SELECT @BusRouteCount = COUNT(busRouteId)
    FROM tbl_busroute br
    INNER JOIN tbl_city s ON br.busRouteStartCityId = s.cityId
    INNER JOIN tbl_city e ON br.busRouteEndCityId = e.cityId
    WHERE s.cityName = @StartCity AND e.cityName = @EndCity;

    RETURN @BusRouteCount;
END;