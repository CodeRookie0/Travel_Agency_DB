---------------------------------------------------------------
--- TRIGGER DEFINITION
--- trg_calculate_booking_prices
---------------------------------------------------------------
-- This trigger is designed to calculate booking prices after INSERT or UPDATE operations on the tbl_booking table.
--
-- Trigger Events:
-- AFTER INSERT, UPDATE
--
-- Result of the action:
-- Calls the stored procedure up_calculate_booking_prices to update booking prices based on the inserted or updated data.
---------------------------------------------------------------
USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_calculate_booking_prices
ON tbl_booking
AFTER INSERT,UPDATE
AS
BEGIN
    DECLARE @bookPackageId INT
    DECLARE @bookDiscountPercent DECIMAL(10, 2)

    SELECT @bookPackageId = bookPackageId,
		   @bookDiscountPercent= bookDiscountPercent
    FROM inserted

    EXEC up_calculate_booking_prices @bookPackageId, @bookDiscountPercent
END

