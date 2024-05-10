--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_generate_popularity_report
--------------------------------------------------------------------------------------------------
-- This procedure generates a popularity report for travel packages. It calculates the total number
-- of bookings made for each package and lists them in descending order of popularity.
--
-- Output Parameters:
-- @packId: The ID of the travel package.
-- @packTitle: The title of the travel package.
-- @TotalBookings: The total number of bookings made for the travel package.
--
-- Example Usage:
-- EXEC up_generate_popularity_report;
--
-- Result of the action:
-- Returns a popularity report listing travel packages based on the total number of bookings made.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_generate_popularity_report
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.packId,
        p.packTitle,
        COUNT(b.bookId) AS TotalBookings
    FROM 
        tbl_package p
    LEFT JOIN 
        tbl_booking b ON p.packId = b.bookPackageId
    GROUP BY 
        p.packId, p.packTitle
    ORDER BY 
        TotalBookings DESC;
END;