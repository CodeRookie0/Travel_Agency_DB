---------------------------------------------------------------
--- FUNCTION DEFINITION
--- uf_return_country_name
---------------------------------------------------------------
-- This function retrieves the name of a country based on its identifier.
--
-- Input Parameters:
-- - @CountryId: The identifier of the country.
--
-- Output Parameters:
-- - @CountryName : The name of the country corresponding to the provided identifier
--
-- Example Usage:
-- SELECT dbo.uf_return_country_name(1);
--
-- Result of the action:
-- Returns the name of the country corresponding to the provided identifier.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER FUNCTION dbo.uf_return_country_name
(
    @CountryId INT
)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @CountryName VARCHAR(100);

    SELECT @CountryName = ctryName
    FROM tbl_country
    WHERE ctryId = @CountryId;

    RETURN @CountryName;
END;