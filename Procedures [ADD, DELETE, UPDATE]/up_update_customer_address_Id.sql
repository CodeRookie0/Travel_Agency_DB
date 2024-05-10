--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_update_customer_address_Id
--------------------------------------------------------------------------------------------------
-- This procedure is used to update the address ID of a customer in the database.
-- It allows associating a different address with an existing customer.
--
-- Input Parameters:
-- @custId: The ID of the customer whose address ID is to be updated.
-- @addrId: The new address ID to be associated with the customer.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_update_customer_address_Id @custId = 123, @addrId = 456
--
-- Result of the action:
-- The customer address ID has been successfully changed
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_update_customer_address_Id
    @custId INT,
    @addrId INT
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT 1 FROM tbl_customer WHERE custId = @custId)
    BEGIN
        RAISERROR('Customer with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

	IF NOT EXISTS (SELECT 1 FROM tbl_address WHERE addrId = @addrId)
    BEGIN
        RAISERROR('Address with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    UPDATE tbl_customer
    SET custAddrId = @addrId
    WHERE custId = @custId;
	PRINT 'The customer address ID has been successfully changed';
END;