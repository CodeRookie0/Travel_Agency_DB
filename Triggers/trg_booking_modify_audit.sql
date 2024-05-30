---------------------------------------------------------------
--- TRIGGER DEFINITION
--- trg_booking_audit
---------------------------------------------------------------
-- This trigger is designed to calculate booking prices after INSERT or UPDATE operations on the tbl_booking table.
--
-- Trigger Events:
-- AFTER INSERT, UPDATE
--
-- Result of the action:
-- Calls the stored procedure up_calculate_booking_prices to update booking prices based on the inserted or updated data,
-- and inserts a record into the tbl_booking_archive table.
---------------------------------------------------------------
USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_booking_audit
ON tbl_booking
AFTER INSERT,UPDATE
AS
BEGIN
    DECLARE @bookPackageId INT
    DECLARE @bookOldPackageId INT
    DECLARE @bookDiscountPercent DECIMAL(10, 2)
	DECLARE @ActionType CHAR(1);

    SET @ActionType = CASE 
          WHEN EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) THEN 'U'
          WHEN EXISTS (SELECT * FROM inserted) THEN 'I'
          ELSE NULL
      END;

	IF @ActionType = 'U'
    BEGIN
        IF NOT EXISTS (
            SELECT *
            FROM inserted i
            INNER JOIN deleted d ON i.bookId = d.bookId
            WHERE 
                i.bookCustId <> d.bookCustId OR
                i.bookPackageId <> d.bookPackageId OR
                i.bookDiscountPercent <> d.bookDiscountPercent OR
                i.bookDiscountAmnt <> d.bookDiscountAmnt OR
                i.bookPrice <> d.bookPrice OR
                i.bookCreatedAt <> d.bookCreatedAt
        )
        BEGIN
            RETURN;
        END;
    END;


	INSERT INTO tbl_booking_archive (archiveAction, bookId, bookCustId, bookPackageId, bookDiscountPercent, bookDiscountAmnt, bookPrice, bookCreatedAt, wasRealized, archivedAt)
    SELECT 
        @ActionType,
        COALESCE(i.bookId, d.bookId),
        COALESCE(i.bookCustId, d.bookCustId),
        COALESCE(i.bookPackageId, d.bookPackageId),
        COALESCE(i.bookDiscountPercent, d.bookDiscountPercent),
        COALESCE(i.bookDiscountAmnt, d.bookDiscountAmnt),
        COALESCE(i.bookPrice, d.bookPrice),
        COALESCE(i.bookCreatedAt, d.bookCreatedAt),
        NULL,
        GETDATE()
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.bookId = d.bookId;

	SELECT @bookPackageId = bookPackageId FROM inserted
    SELECT @bookOldPackageId = bookPackageId FROM deleted

	 IF @ActionType = 'U'
	 BEGIN
		IF @bookPackageId <> @bookOldPackageId
		BEGIN
			UPDATE tbl_package
			SET packCurrentBookings = packCurrentBookings - 1
			WHERE packId = @bookOldPackageId;

			UPDATE tbl_package
			SET packCurrentBookings = packCurrentBookings + 1
			WHERE packId = @bookPackageId;
		END;
	END;

	IF @ActionType = 'I'
    BEGIN
        UPDATE tbl_package
        SET packCurrentBookings = (SELECT COUNT(*) FROM tbl_booking WHERE bookPackageId = @bookPackageId)
        WHERE packId = @bookPackageId;
    END;
END

