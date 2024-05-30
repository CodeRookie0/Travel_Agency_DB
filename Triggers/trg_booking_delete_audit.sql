---------------------------------------------------------------
--- TRIGGER DEFINITION
--- trg_booking_delete_audit
---------------------------------------------------------------
-- This trigger is designed to audit DELETE operations on the tbl_booking table.
--
-- Trigger Events:
-- AFTER DELETE
--
-- Example Usage:
-- No direct usage. This trigger automatically executes after DELETE operations on the tbl_booking table.
--
-- Result of the action:
-- Adds records to the tbl_booking_archive table with an indication of the action performed (DELETE) 
-- and including the details of the deleted booking.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_booking_delete_audit
ON tbl_booking
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @bookPackageId INT;

    INSERT INTO tbl_booking_archive (archiveAction, bookId, bookCustId, bookPackageId, bookDiscountPercent, bookDiscountAmnt, bookPrice, bookCreatedAt, archivedAt, wasRealized)
    SELECT 
        'D',
        d.bookId,
        d.bookCustId,
        d.bookPackageId,
        d.bookDiscountPercent,
        d.bookDiscountAmnt,
        d.bookPrice,
        d.bookCreatedAt,
        GETDATE(),
        CASE 
            WHEN p.packCurrentBookings >= p.packMinCapacity AND p.packStartDate < GETDATE() THEN 1 
            WHEN p.packCurrentBookings < p.packMinCapacity AND p.packStartDate < GETDATE() THEN 0 
            ELSE NULL
        END
    FROM deleted d
    JOIN tbl_package p ON d.bookPackageId = p.packId;

	SELECT @bookPackageId = bookPackageId FROM deleted;

	IF ((SELECT packStartDate FROM tbl_package WHERE packId = @bookPackageId) >= GETDATE())
    BEGIN
		UPDATE tbl_package
		SET packCurrentBookings = (SELECT COUNT(*) FROM tbl_booking WHERE bookPackageId = @bookPackageId)
		WHERE packId = @bookPackageId;
	END;
END;