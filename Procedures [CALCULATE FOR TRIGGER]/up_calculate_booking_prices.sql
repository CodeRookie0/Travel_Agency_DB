--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_calculate_booking_prices
--------------------------------------------------------------------------------------------------
-- This procedure calculates and updates the prices for bookings associated with a specified package
--
-- This procedure is triggered when inserting or modifying a record in the tbl_booking table.
--
-- Input Parameters:
-- @bookPackageId: The ID of the package for which booking prices need to be calculated and updated (required).
-- @bookDiscountPercent: The discount percentage applied to the package price (required).
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_calculate_booking_prices @bookPackageId = 1, @bookDiscountPercent = 0.1;
--
-- Result of the action:
-- The prices for bookings associated with the specified package have been successfully calculated
-- and updated.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO


ALTER PROCEDURE up_calculate_booking_prices 
    @bookPackageId INT,
    @bookDiscountPercent DECIMAL(10, 2)
AS
BEGIN
    DECLARE @packPrice DECIMAL(10, 2)
    DECLARE @bookDiscountAmnt DECIMAL(10, 2)
    DECLARE @bookPrice DECIMAL(10, 2)

    SELECT @packPrice = packPrice
    FROM tbl_package
    WHERE packId = @bookPackageId

    SET @bookDiscountAmnt = @packPrice * @bookDiscountPercent

    SET @bookPrice = @packPrice - @bookDiscountAmnt

    UPDATE tbl_booking
    SET bookDiscountAmnt = @bookDiscountAmnt,
        bookPrice = @bookPrice
    WHERE bookPackageId = @bookPackageId
END