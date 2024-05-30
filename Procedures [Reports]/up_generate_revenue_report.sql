--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_generate_revenue_report
--------------------------------------------------------------------------------------------------
-- This procedure generates a revenue report for a specified month and year. It calculates the total
-- revenue generated in the given month and year based on the bookings made during that period.
--
-- Input Parameters:
-- @month: The month for which the revenue report is generated.
-- @year: The year for which the revenue report is generated.
--
-- Output Parameters:
-- @BookedMonth: The month of the bookings.
-- @BookedYear: The year of the bookings.
-- @TotalRevenue: The total revenue generated in the specified month and year.
--
-- Example Usage:
-- EXEC up_generate_revenue_report @month = 5, @year = 2024;
--
-- Result of the action:
-- Returns a revenue report for the specified month and year.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_generate_revenue_report
    @month INT,
    @year INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        MONTH(b.bookCreatedAt) AS BookedMonth,
        YEAR(b.bookCreatedAt) AS BookedYear,
        CAST(SUM((((b.bookPrice + b.bookDiscountAmnt) / 115) * 15) - b.bookDiscountAmnt) AS DECIMAL(10, 2)) AS TotalRevenue
    FROM 
        tbl_booking_archive b
    WHERE 
        MONTH(b.bookCreatedAt) = @month AND YEAR(b.bookCreatedAt) = @year AND wasRealized=1
    GROUP BY 
        MONTH(b.bookCreatedAt), YEAR(b.bookCreatedAt);
END;