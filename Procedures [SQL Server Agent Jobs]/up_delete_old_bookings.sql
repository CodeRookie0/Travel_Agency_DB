--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_delete_old_bookings
--------------------------------------------------------------------------------------------------
-- This procedure is used to delete old bookings from the database.
-- Bookings associated with packages whose start dates are earlier than the current date will be removed.
--
-- Example Usage:
-- EXEC up_delete_old_bookings
--
-- Result of the action:
-- Old bookings associated with packages starting before the current date were successfully deleted.
--------------------------------------------------------------------------------------------------


USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_delete_old_bookings
AS
BEGIN
    DELETE FROM tbl_booking
	WHERE bookPackageId IN (
		SELECT packId 
		FROM tbl_package
		WHERE packStartDate < GETDATE()
	);
END
GO