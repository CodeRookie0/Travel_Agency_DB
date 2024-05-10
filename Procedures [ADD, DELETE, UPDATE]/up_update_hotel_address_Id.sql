--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_update_hotel_address_Id
--------------------------------------------------------------------------------------------------
-- This procedure is used to update the address ID of a hotel in the database.
--
-- Input Parameters:
-- @hotId: The ID of the hotel to update its address ID.
-- @addrId: The new address ID to be associated with the hotel.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_update_hotel_address_Id @hotId = 123, @addrId = 456
--
-- Result of the action:
-- The hotel address ID has been successfully changed.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_update_hotel_address_Id
    @hotId INT,
    @addrId INT
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT 1 FROM tbl_hotel WHERE hotId = @hotId)
    BEGIN
        RAISERROR('Hotel with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

	IF NOT EXISTS (SELECT 1 FROM tbl_address WHERE addrId = @addrId)
    BEGIN
        RAISERROR('Address with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    UPDATE tbl_hotel
    SET hotAddrId = @addrId
    WHERE hotId = @hotId;

	PRINT 'The hotel address ID has been successfully changed';
END;
