--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_get_hotel_bookings
--------------------------------------------------------------------------------------------------
-- This procedure retrieves bookings made for a specific hotel identified by its hotel ID.
--
-- Input Parameters:
-- @hotelId: The ID of the hotel for which bookings are to be retrieved.
--
-- Output Columns:
-- @hotId: The ID of the hotel.
-- @hotName: The name of the hotel.
-- @bookId: The ID of the booking.
-- @packTitle: The title of the travel package booked.
-- @packStartDate: The start date of the travel package booked.
-- @packEndDate: The end date of the travel package booked.
-- @bookPrice: The price of the booking.
-- @bookDiscountAmnt: The discount amount applied to the booking.
-- @hotPricePerNight: The price per night of the hotel.
-- @hotelTotalPrice: The total price of the hotel stay for the duration of the package.
--
-- Example Usage:
-- EXEC up_get_hotel_bookings 189;
--
-- Result of the action:
-- Returns the bookings made for the specified hotel.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_get_hotel_bookings
    @hotelId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
		h.hotId,
		h.hotName,
        b.bookId,
        p.packTitle,
        p.packStartDate,
        p.packEndDate,
        b.bookPrice,
        b.bookDiscountAmnt, 
        h.hotPricePerNight,
		h.hotPricePerNight * p.packDuration AS hotelTotalPrice
    FROM 
        tbl_booking b
    INNER JOIN 
        tbl_package p ON b.bookPackageId = p.packId
    INNER JOIN 
        tbl_hotel h ON p.packHotId = h.hotId
    WHERE 
        h.hotId = @hotelId;
END;