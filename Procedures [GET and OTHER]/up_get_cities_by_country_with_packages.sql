--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_get_cities_by_country_with_packages
--------------------------------------------------------------------------------------------------
-- This procedure retrieves distinct cities from a specified country that have packages
-- associated with them. It returns the names of the cities based on the provided country name.
--
-- Input Parameters:
-- @countryName: The name of the country for which cities with associated packages are
--               retrieved (required).
--
-- Output Parameters:
-- @CityName: The name of the city with packages associated with it.
--
-- Example Usage:
-- EXEC up_get_cities_by_country_with_packages @countryName = 'France';
--
-- Result of the action:
-- Returns the distinct cities from the specified country that have packages associated with them.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_get_cities_by_country_with_packages
    @countryName VARCHAR(45)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT
        ci.cityName
    FROM 
        tbl_city ci
    INNER JOIN 
        tbl_country co ON ci.ctryId = co.ctryId
    INNER JOIN 
        tbl_package p ON p.packCityId = ci.cityId
    WHERE 
        co.ctryName = @countryName;
END;