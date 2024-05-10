--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_delete_hotel_and_address
--------------------------------------------------------------------------------------------------
-- This procedure is used to delete a hotel along with its address from the database.
--
-- Input Parameters:
-- @hotId: The ID of the hotel to be deleted.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_delete_hotel_and_address @hotId = 123
--
-- Result of the action:
-- The hotel and its address have been successfully deleted.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_delete_hotel_and_address
    @hotId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @addrId INT;

	IF NOT EXISTS (SELECT 1 FROM tbl_hotel WHERE hotId = @hotId)
    BEGIN
        RAISERROR('Hotel with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    SELECT @addrId = hotAddrId FROM tbl_hotel WHERE hotId = @hotId;

    IF EXISTS (SELECT 1 FROM tbl_package WHERE packHotId = @hotId)
    BEGIN
        RAISERROR('The hotel is associated with one or more packages and cannot be deleted.', 16, 1);
        RETURN;
    END;

    DELETE FROM tbl_hotel WHERE hotId = @hotId;

    DELETE FROM tbl_address WHERE addrId = @addrId;

    PRINT 'The hotel and its address have been successfully deleted.';
END;
GO