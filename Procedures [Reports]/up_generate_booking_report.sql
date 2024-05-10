--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_generate_booking_report
--------------------------------------------------------------------------------------------------
-- This procedure generates a booking report for a specified time range. It retrieves booking details
-- including customer information, package details, and pricing for bookings created within the given
-- start and end dates.
--
-- Input Parameters:
-- @startDate: The start date for the booking report.
-- @endDate: The end date for the booking report.
--
-- Output Parameters:
-- @bookId: The ID of the booking.
-- @bookCustId: The ID of the customer who made the booking.
-- @custName: The name of the customer who made the booking.
-- @custSurname: The surname of the customer who made the booking.
-- @bookPackageId: The ID of the package booked.
-- @packTitle: The title of the package booked.
-- @bookPrice: The price of the booking.
-- @bookDiscountAmnt: The amount of discount applied to the booking.
-- @destinationCity: The destination city of the booked package.
-- @bookDiscountPercent: The percentage of discount applied to the booking.
-- @totalPrice: The total price after applying the discount.
--
-- Example Usage:
-- EXEC up_generate_booking_report @startDate = '2024-01-01', @endDate = '2024-12-31';
--
-- Result of the action:
-- Returns a booking report for bookings created within the specified time range.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_generate_booking_report
    @startDate DATE,
    @endDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        b.bookId,
        b.bookCustId,
        c.custName,
        c.custSurname,
        b.bookPackageId,
        p.packTitle,
        (SELECT cityName FROM tbl_city WHERE cityId = p.packCityId) AS destinationCity,
        b.bookPrice + b.bookDiscountAmnt AS packagePrice,
        b.bookDiscountPercent,
        b.bookDiscountAmnt,
        b.bookPrice
    FROM 
        tbl_booking b
    INNER JOIN 
        tbl_customer c ON b.bookCustId = c.custId
    INNER JOIN 
        tbl_package p ON b.bookPackageId = p.packId
    WHERE 
         b.bookCreatedAt BETWEEN @startDate AND @endDate;
END;