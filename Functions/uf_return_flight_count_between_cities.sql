---------------------------------------------------------------
--- FUNCTION DEFINITION
--- uf_return_flight_count_between_cities
---------------------------------------------------------------
-- This function calculates the number of flights available between two specified cities.
--
-- Input Parameters:
-- - @StartCity: The name of the starting city.
-- - @EndCity: The name of the destination city.
--
-- Output Parameters:
-- - @FlightCount : The count of flights available between the specified start and end cities.
--
-- Example Usage:
-- SELECT dbo.uf_return_flight_count_between_cities('Norsup', 'Port Vila');
--
-- Result of the action:
-- Returns the count of flights available between the specified start and end cities.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER FUNCTION dbo.uf_return_flight_count_between_cities
(
    @StartCity VARCHAR(60),
    @EndCity VARCHAR(60)
)
RETURNS INT
AS
BEGIN
    DECLARE @FlightCount INT;

    SELECT @FlightCount = COUNT(fliId)
    FROM tbl_flight f
    INNER JOIN tbl_city s ON f.fliStartCityId = s.cityId
    INNER JOIN tbl_city e ON f.fliEndCityId = e.cityId
    WHERE s.cityName = @StartCity AND e.cityName = @EndCity;

    RETURN @FlightCount;
END;