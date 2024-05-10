--------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_delete_customer_and_address
--------------------------------------------------------------------------------------
-- This procedure deletes a customer along with their address from the database.
--
-- Input Parameters:
-- @custId: INT - The ID of the customer to be deleted.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_delete_customer_and_address @custId = 123
--
-- Sample Output:
-- The client has been successfully deleted.
-- The customer's address has been successfully deleted.
--
--------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER  PROCEDURE up_delete_customer_and_address
    @custId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @addrId INT;

    IF NOT EXISTS (SELECT 1 FROM tbl_customer WHERE custId = @custId)
    BEGIN
        RAISERROR('Customer with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

	IF EXISTS (SELECT 1 FROM tbl_booking WHERE bookCustId = @custId)
    BEGIN
        RAISERROR('The customer is associated with one or more bookings and cannot be deleted.', 16, 1);
        RETURN;
    END;

    SELECT @addrId = custAddrId FROM tbl_customer WHERE custId = @custId;

    DELETE FROM tbl_customer WHERE custId = @custId;
    PRINT 'The client has been successfully deleted.';

    DELETE FROM tbl_address WHERE addrId = @addrId;
    PRINT 'The customer''s address has been successfully deleted.';

END;
GO