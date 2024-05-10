--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_add_booking
--------------------------------------------------------------------------------------------------
-- This procedure is used to add a booking for a customer and a package in the database.
--
-- Input Parameters:
-- @bookCustId: The ID of the customer making the booking (required).
-- @bookPackageId: The ID of the package being booked (required).
-- @bookDiscountPercent: The discount percentage for the booking (required).
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_add_booking @bookCustId = 1, @bookPackageId = 2, @bookDiscountPercent = 0.2;
--
-- Result of the action:
-- The booking has been successfully added.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_add_booking
    @bookCustId INT,
    @bookPackageId INT,
    @bookDiscountPercent FLOAT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM tbl_customer WHERE custId = @bookCustId)
    BEGIN
        RAISERROR('The specified customer ID does not exist.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM tbl_package WHERE packId = @bookPackageId)
    BEGIN
        RAISERROR('The specified package ID does not exist.', 16, 1);
        RETURN;
    END;

	IF @bookDiscountPercent < 0 OR @bookDiscountPercent > 1
    BEGIN
        RAISERROR('The discount percentage must be between 0 and 1.', 16, 1);
        RETURN;
    END;

    INSERT INTO tbl_booking(bookCustId, bookPackageId, bookDiscountPercent,bookPrice)
    VALUES (@bookCustId, @bookPackageId, @bookDiscountPercent,1);

	PRINT 'The booking has been successfully added.';
END;
GO