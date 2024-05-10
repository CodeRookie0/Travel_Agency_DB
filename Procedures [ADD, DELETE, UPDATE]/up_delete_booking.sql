--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_delete_booking
--------------------------------------------------------------------------------------------------
-- This procedure is used to delete a booking from the database based on the booking ID.
--
-- Input Parameters:
-- @bookId: The ID of the booking to be deleted (required).
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_delete_booking @bookId = 1;
--
-- Result of the action:
-- The booking has been successfully deleted.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_delete_booking
    @bookId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @confirmation CHAR(1);

    IF NOT EXISTS (SELECT 1 FROM tbl_booking WHERE bookId = @bookId)
    BEGIN
        RAISERROR('The specified booking ID does not exist.', 16, 1);
        RETURN;
    END;

   DELETE FROM tbl_booking WHERE bookId = @bookId;

   PRINT 'The booking has been successfully deleted.';
END;
GO