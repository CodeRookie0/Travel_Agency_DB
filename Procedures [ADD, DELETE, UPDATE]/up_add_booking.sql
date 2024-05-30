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

	IF (SELECT packCurrentBookings FROM tbl_package WHERE packId = @bookPackageId) = (SELECT packMaxCapacity FROM tbl_package WHERE packId = @bookPackageId)
    BEGIN
        RAISERROR('The maximum capacity for this package has been reached.', 16, 1);
        RETURN;
    END;

	IF @bookDiscountPercent < 0 OR @bookDiscountPercent > 1
    BEGIN
        RAISERROR('The discount percentage must be between 0 and 1.', 16, 1);
        RETURN;
    END;

	DECLARE @packPrice DECIMAL(10, 2)
    DECLARE @bookDiscountAmnt DECIMAL(10, 2)
    DECLARE @bookPrice DECIMAL(10, 2)

	SELECT @packPrice = packPrice
    FROM tbl_package
    WHERE packId = @bookPackageId;

    SET @bookDiscountAmnt = @packPrice * @bookDiscountPercent;

    SET @bookPrice = @packPrice - @bookDiscountAmnt;

    INSERT INTO tbl_booking(bookCustId, bookPackageId, bookDiscountPercent, bookDiscountAmnt, bookPrice)
    VALUES (@bookCustId, @bookPackageId, @bookDiscountPercent, @bookDiscountAmnt, @bookPrice);

	PRINT 'The booking has been successfully added.';
END;
GO