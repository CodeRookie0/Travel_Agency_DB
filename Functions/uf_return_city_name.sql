---------------------------------------------------------------
--- FUNCTION DEFINITION
--- uf_return_city_name
---------------------------------------------------------------
-- This function retrieves the name of a city based on its identifier.
--
-- Input Parameters:
-- - @CityId: The identifier of the city.
--
-- Output Parameters:
-- - @CityName : The name of the city corresponding to the provided identifier.
--
-- Example Usage:
-- SELECT dbo.uf_return_city_name(1);
--
-- Result of the action:
-- Returns the name of the city corresponding to the provided identifier.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER FUNCTION dbo.uf_return_city_name
(
    @CityId INT
)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @CityName VARCHAR(100);

    SELECT @CityName = cityName
    FROM tbl_city
    WHERE cityId = @CityId;

    RETURN @CityName;
END;
