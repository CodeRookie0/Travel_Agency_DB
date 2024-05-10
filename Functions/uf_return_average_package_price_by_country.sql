---------------------------------------------------------------
--- FUNCTION DEFINITION
--- uf_return_average_package_price_by_country
---------------------------------------------------------------
-- This function calculates the average package price for a given country by computing the average price of all packages offered in that country.
--
-- Input Parameters:
-- - @CountryName: The name of the country for which the average package price is to be calculated.
--
-- Output Parameters:
-- - @AveragePrice : The average package price for the specified country
--
-- Example Usage:
-- SELECT dbo.uf_return_average_package_price_by_country('France');
--
-- Result of the action:
-- Returns the average package price for the specified country as DECIMAL(10, 2).
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER FUNCTION dbo.uf_return_average_package_price_by_country
(
    @CountryName VARCHAR(45)
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @AveragePrice DECIMAL(10, 2);

    SELECT @AveragePrice = AVG(p.packPrice)
    FROM tbl_package p
    INNER JOIN tbl_city c ON p.packCityId = c.cityId
    INNER JOIN tbl_country co ON c.ctryId = co.ctryId
    WHERE co.ctryName = @CountryName;

    RETURN @AveragePrice;
END;