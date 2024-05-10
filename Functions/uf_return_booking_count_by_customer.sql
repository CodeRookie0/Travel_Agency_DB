---------------------------------------------------------------
--- FUNCTION DEFINITION
--- uf_return_booking_count_by_customer
---------------------------------------------------------------
-- This function calculates the total number of bookings made by a given customer.
--
-- Input Parameters:
-- - @CustomerId: The identifier of the customer for whom the total booking count is to be calculated.
--
-- Output Parameters:
-- - @BookingCount : The total number of bookings made by the specified customer as INT.
--
-- Example Usage:
-- SELECT dbo.uf_return_booking_count_by_customer(123);
--
-- Result of the action:
-- Returns the total number of bookings made by the specified customer as INT.
---------------------------------------------------------------

USE TRAVEL_AGENCY
Go

CREATE OR ALTER FUNCTION dbo.uf_return_booking_count_by_customer
(
    @CustomerId INT
)
RETURNS INT
AS
BEGIN
    DECLARE @BookingCount INT;

    SELECT @BookingCount = COUNT(bookId)
    FROM tbl_booking
    WHERE bookCustId = @CustomerId;

    RETURN @BookingCount;
END;