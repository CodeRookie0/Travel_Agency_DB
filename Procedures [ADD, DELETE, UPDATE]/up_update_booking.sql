--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_update_booking
--------------------------------------------------------------------------------------------------
-- This procedure is used to update the details of a booking in the database based on the booking ID.
--
-- Input Parameters:
-- @bookId: The ID of the booking to be updated (required).
-- @bookCustId: The ID of the customer associated with the booking (optional).
-- @bookPackageId: The ID of the package associated with the booking (optional).
-- @bookDiscountPercent: The discount percentage applied to the booking (optional).
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_update_booking @bookId = 1, @bookPackageId = 5, @bookDiscountPercent = 0.1;
--
-- Result of the action:
-- Booking data has been successfully modified.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_update_booking
    @bookId INT,
    @bookCustId INT = NULL,
    @bookPackageId INT = NULL,
    @bookDiscountPercent FLOAT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM tbl_booking WHERE bookId = @bookId)
    BEGIN
        RAISERROR('The specified booking ID does not exist.', 16, 1);
        RETURN;
    END;

    IF @bookCustId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbl_customer WHERE custId = @bookCustId)
    BEGIN
        RAISERROR('The specified customer ID does not exist.', 16, 1);
        RETURN;
    END;

    IF @bookPackageId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbl_package WHERE packId = @bookPackageId)
    BEGIN
        RAISERROR('The specified package ID does not exist.', 16, 1);
        RETURN;
    END;

	SELECT @bookPackageId = COALESCE(@bookPackageId, bookPackageId) FROM tbl_booking WHERE bookId = @bookId;
    SELECT @bookDiscountPercent = COALESCE(@bookDiscountPercent, bookDiscountPercent) FROM tbl_booking WHERE bookId = @bookId;

    UPDATE tbl_booking
    SET 
        bookCustId = COALESCE(@bookCustId, bookCustId),
        bookPackageId = @bookPackageId,
        bookDiscountPercent = @bookDiscountPercent
    WHERE bookId = @bookId;

	PRINT 'Booking data has been successfully modified.'
END;
GO