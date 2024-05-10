---------------------------------------------------------------
--- FUNCTION DEFINITION
--- uf_return_hotel_count_by_stars_and_country
---------------------------------------------------------------
-- This function calculates the number of hotels with a specified number of stars in a given country.
--
-- Input Parameters:
-- - @Stars: The number of stars of the hotels.
-- - @CountryName: The name of the country.
--
-- Output Parameters:
-- - @HotelCount : The count of hotels with the specified number of stars in the specified country.
--
-- Example Usage:
-- SELECT dbo.uf_return_hotel_count_by_stars_and_country(5, 'France');
--
-- Result of the action:
-- Returns the count of hotels with the specified number of stars in the specified country.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER FUNCTION dbo.uf_return_hotel_count_by_stars_and_country
(
    @Stars INT,
    @CountryName VARCHAR(45)
)
RETURNS INT
AS
BEGIN
    DECLARE @HotelCount INT;

    SELECT @HotelCount = COUNT(hotId)
    FROM tbl_hotel h
    INNER JOIN tbl_address a ON h.hotAddrId = a.addrId
    INNER JOIN tbl_city c ON a.addrCityId = c.cityId
    INNER JOIN tbl_country co ON c.ctryId = co.ctryId
    WHERE hotStars = @Stars AND co.ctryName = @CountryName;

    RETURN @HotelCount;
END;