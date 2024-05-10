---------------------------------------------------------------
--- FUNCTION DEFINITION
--- uf_return_average_hotel_price_by_city
---------------------------------------------------------------
-- This function calculates the average price per night of hotels in a specific city.
--
-- Input Parameters:
-- - @CityName: The name of the city for which the average hotel price is to be calculated.
--
-- Output Parameters:
-- - @AveragePrice : The average price per night of hotels in the specified city
--
-- Example Usage:
-- SELECT dbo.uf_return_average_hotel_price_by_city('Paris');
--
-- Result of the action:
-- Returns the average price per night of hotels in the specified city as DECIMAL(10, 2).
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER FUNCTION dbo.uf_return_average_hotel_price_by_city
(
    @CityName VARCHAR(60)
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @AveragePrice DECIMAL(10, 2);

    SELECT @AveragePrice = AVG(hotPricePerNight)
    FROM tbl_hotel h
    INNER JOIN tbl_address a ON h.hotAddrId = a.addrId
    INNER JOIN tbl_city c ON a.addrCityId = c.cityId
    WHERE c.cityName = @CityName;

    RETURN @AveragePrice;
END;