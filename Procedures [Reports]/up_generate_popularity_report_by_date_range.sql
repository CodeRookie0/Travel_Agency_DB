--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_generate_popularity_report_by_date_range
--------------------------------------------------------------------------------------------------
-- This procedure generates a popularity report for travel packages within a specified date range. 
-- It calculates the total number of bookings made for each package during the specified period 
-- and lists them in descending order of popularity.
--
-- Input Parameters:
-- @startDate: The start date of the date range.
-- @endDate: The end date of the date range.
--
-- Output Parameters:
-- @packId: The ID of the travel package.
-- @packTitle: The title of the travel package.
-- @TotalBookings: The total number of bookings made for the travel package within the date range.
--
-- Example Usage:
-- EXEC up_generate_popularity_report_by_date_range '2024-01-01', '2024-12-31';
--
-- Result of the action:
-- Returns a popularity report for travel packages within the specified date range.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_generate_popularity_report_by_date_range
    @startDate DATE,
    @endDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        packId,
        packTitle,
        COUNT(DISTINCT bookingId) AS TotalBookings
    FROM 
        (
            SELECT b.bookId AS bookingId, p.packId, p.packTitle
            FROM tbl_package p
            LEFT JOIN tbl_booking b ON p.packId = b.bookPackageId
            WHERE b.bookCreatedAt BETWEEN @startDate AND @endDate
            
            UNION ALL
            
            SELECT ba.bookId AS bookingId, p.packId, p.packTitle
            FROM tbl_package p
            LEFT JOIN tbl_booking_archive ba ON p.packId = ba.bookPackageId
            WHERE ba.bookCreatedAt BETWEEN @startDate AND @endDate AND ba.wasRealized = 1
        ) AS CombinedBookings
    GROUP BY 
        packId, packTitle
    ORDER BY 
        TotalBookings DESC;
END;
