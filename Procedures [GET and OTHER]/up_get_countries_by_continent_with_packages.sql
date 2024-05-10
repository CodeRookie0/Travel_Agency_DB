--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_get_countries_by_continent_with_packages
--------------------------------------------------------------------------------------------------
-- This procedure retrieves distinct countries from a specified continent that have packages
-- associated with them. It returns the country IDs and names based on the provided continent name.
--
-- Input Parameters:
-- @continentName: The name of the continent for which countries with associated packages are
--                 retrieved (required).
--
-- Output Parameters:
-- @CountryId: The ID of the country with packages associated with it.
-- @CountryName: The name of the country with packages associated with it.
--
-- Example Usage:
-- EXEC up_get_countries_by_continent_with_packages @continentName = 'Europe';
--
-- Result of the action:
-- Returns the distinct countries from the specified continent that have packages associated with
-- them.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_get_countries_by_continent_with_packages
    @continentName VARCHAR(25)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT
		c.ctryId,
        c.ctryName
    FROM 
        tbl_country c
    INNER JOIN 
        tbl_city ci ON c.ctryId = ci.ctryId
    INNER JOIN 
        tbl_continent co ON c.contId = co.contId
    INNER JOIN 
        tbl_package p ON p.packCityId = ci.cityId
    WHERE 
        co.contName = @continentName;
END;