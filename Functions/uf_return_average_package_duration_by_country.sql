---------------------------------------------------------------
--- FUNCTION DEFINITION
--- uf_return_average_package_duration_by_country
---------------------------------------------------------------
-- This function calculates the average package duration for a given country by computing the average duration of all packages offered in that country.
--
-- Input Parameters:
-- - @CountryName: The name of the country for which the average package duration is to be calculated.
--
-- Output Parameters:
-- - @AverageDuration :  The average package duration for the specified country
--
-- Example Usage:
-- SELECT dbo.uf_return_average_package_duration_by_country('France');
--
-- Result of the action:
-- Returns the average package duration for the specified country as DECIMAL(10, 2).
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER FUNCTION dbo.uf_return_average_package_duration_by_country
(
    @CountryName VARCHAR(45)
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @AverageDuration DECIMAL(10, 2);

    SELECT @AverageDuration = AVG(packDuration)
    FROM tbl_package p
    INNER JOIN tbl_city c ON p.packCityId = c.cityId
    INNER JOIN tbl_country co ON c.ctryId = co.ctryId
    WHERE co.ctryName = @CountryName;

    RETURN @AverageDuration;
END;