---------------------------------------------------------------
--- FUNCTION DEFINITION
--- uf_return_total_booking_price_by_customer
---------------------------------------------------------------
-- This function calculates the total booking price for a given customer by summing up the prices of all bookings made by that customer.
--
-- Input Parameters:
-- - @CustomerId: The identifier of the customer for whom the total booking price is to be calculated.
--
-- Output Parameters:
-- - @TotalPrice : The total booking price for the specified customer
--
-- Example Usage:
-- SELECT dbo.uf_return_total_booking_price_by_customer(123);
--
-- Result of the action:
-- Returns the total booking price for the specified customer as DECIMAL(10, 2).
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER FUNCTION dbo.uf_return_total_booking_price_by_customer
(
    @CustomerId INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalPrice DECIMAL(10, 2);

    SELECT @TotalPrice = SUM(bookPrice)
    FROM tbl_booking
    WHERE bookCustId = @CustomerId;

    RETURN @TotalPrice;
END;