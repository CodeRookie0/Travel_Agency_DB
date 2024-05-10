---------------------------------------------------------------
--- FUNCTION DEFINITION
--- uf_return_total_income_by_year
---------------------------------------------------------------
-- This function calculates the total income generated in a specific year by summing up the net income (total booking price after deducting discounts and taxes) of all bookings made in that year.
--
-- Input Parameters:
-- - @Year: The year for which the total income is to be calculated.
--
-- Output Parameters:
-- - @TotalIncome : The total income generated in the specified year
--
-- Example Usage:
-- SELECT dbo.uf_return_total_income_by_year(2023);
--
-- Result of the action:
-- Returns the total income generated in the specified year as DECIMAL(10, 2).
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER FUNCTION dbo.uf_return_total_income_by_year
(
    @Year INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalIncome DECIMAL(10, 2);

    SELECT @TotalIncome = SUM((((bookPrice + bookDiscountAmnt) / 115) * 15) - bookDiscountAmnt)
    FROM tbl_booking
    WHERE YEAR(bookCreatedAt) = @Year;

    RETURN @TotalIncome;
END;