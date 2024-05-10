--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_get_customer_bookings
--------------------------------------------------------------------------------------------------
-- This procedure retrieves bookings made by a specific customer identified by their customer ID.
--
-- Input Parameters:
-- @customerId: The ID of the customer whose bookings are to be retrieved.
--
-- Output Columns:
-- @bookId: The ID of the booking.
-- @packTitle: The title of the travel package booked.
-- @packStartDate: The start date of the travel package booked.
-- @packEndDate: The end date of the travel package booked.
-- @bookPrice: The price of the booking.
-- @bookDiscountAmnt: The discount amount applied to the booking.
--
-- Example Usage:
-- EXEC up_get_customer_bookings @customerId=56;
--
-- Result of the action:
-- Returns the bookings made by the specified customer.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_get_customer_bookings
    @customerId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        b.bookId,
        p.packTitle,
        p.packStartDate,
        p.packEndDate,
        b.bookPrice,
        b.bookDiscountAmnt
    FROM 
        tbl_booking b
    INNER JOIN 
        tbl_package p ON b.bookPackageId = p.packId
    WHERE 
        b.bookCustId = @customerId;
END;