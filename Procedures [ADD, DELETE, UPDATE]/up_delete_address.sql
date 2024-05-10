--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_delete_address
--------------------------------------------------------------------------------------------------
-- This procedure is used to delete an address from the database.
--
-- Input Parameters:
-- @addrId: The ID of the address to be deleted.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_delete_address @addrId = 123
--
-- Result of the action:
-- The address was successfully deleted.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER  PROCEDURE up_delete_address
    @addrId INT
AS
BEGIN
    SET NOCOUNT ON;

	IF NOT EXISTS (SELECT 1 FROM tbl_address WHERE addrId = @addrId)
    BEGIN
        RAISERROR('Address with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM tbl_customer WHERE custAddrId = @addrId)
    BEGIN
        RAISERROR('The address is still associated with one or more customers and cannot be deleted.', 16, 1);
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM tbl_hotel WHERE hotAddrId = @addrId)
    BEGIN
        RAISERROR('The address is still associated with one or more hotels and cannot be deleted.', 16, 1);
        RETURN;
    END;

    DELETE FROM tbl_address WHERE addrId = @addrId;
    PRINT 'The address was successfully deleted.';
END;
GO