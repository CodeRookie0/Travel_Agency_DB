--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_search_travel_packages
--------------------------------------------------------------------------------------------------
-- This procedure searches for travel packages based on various criteria such as destination city,
-- start and end dates, maximum price, and preferred mode of transport. It returns packages that match
-- the specified criteria.
--
-- Input Parameters:
-- @destinationCityId: The ID of the destination city for the travel packages (optional).
-- @startDate: The start date for the travel packages (optional).
-- @endDate: The end date for the travel packages (optional).
-- @maxPrice: The maximum price for the travel packages (optional).
-- @preferredTransport: The preferred mode of transport for the travel packages ('flight', 'bus', or NULL for any) (optional).
--
-- Output Parameters:
-- @packId: The ID of the travel package.
-- @packTitle: The title of the travel package.
-- @packDescription: The description of the travel package.
-- @packPrice: The price of the travel package.
-- @packStartDate: The start date of the travel package.
-- @packEndDate: The end date of the travel package.
-- @destinationCity: The destination city of the travel package.
-- @hotelName: The name of the hotel associated with the travel package.
-- @hotelStars: The star rating of the hotel associated with the travel package.
--
-- Example Usage:
-- EXEC up_search_travel_packages @destinationCityId = 123, @startDate = '2024-04-01', @endDate = '2024-04-10', @maxPrice = 2000.00, @preferredTransport = 'flight';
--
-- Result of the action:
-- Returns travel packages that match the specified criteria.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_search_travel_packages
    @destinationCityId INT = NULL,
    @startDate DATE = NULL,
    @endDate DATE = NULL,
    @maxPrice DECIMAL(10, 2) = NULL,
    @preferredTransport VARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        packId,
        packTitle,
        packDescription,
        packPrice,
        packStartDate,
        packEndDate,
        (SELECT cityName FROM tbl_city WHERE cityId = packCityId) AS destinationCity,
        (SELECT hotName FROM tbl_hotel WHERE hotId = packHotId) AS hotelName,
        (SELECT hotStars FROM tbl_hotel WHERE hotId = packHotId) AS hotelStars
    FROM 
        tbl_package
    WHERE 
        (packCityId = @destinationCityId OR @destinationCityId IS NULL)
        AND (packStartDate >= @startDate OR @startDate IS NULL)
        AND (packEndDate <= @endDate OR @endDate IS NULL)
        AND (packPrice <= @maxPrice OR @maxPrice IS NULL)
		AND 
        (
            (@preferredTransport = 'flight' AND packOutboundFlightId IS NOT NULL AND packReturnFlightId IS NOT NULL) OR
            (@preferredTransport = 'bus' AND packOutboundBusRouteId IS NOT NULL AND packReturnBusRouteId IS NOT NULL) OR
            (@preferredTransport IS NULL OR @preferredTransport NOT IN ('flight', 'bus'))
        );
END;