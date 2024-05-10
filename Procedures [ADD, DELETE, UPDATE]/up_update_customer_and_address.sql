--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_update_customer_and_address
--------------------------------------------------------------------------------------------------
-- This procedure is used to update customer and address details in the database.
-- It allows updating various attributes of a customer and their associated address.
--
-- Input Parameters:
-- @custId: The ID of the customer to be updated.
-- @custName: (Optional) The new name of the customer.
-- @custSurname: (Optional) The new surname of the customer.
-- @custPhone: (Optional) The new phone number of the customer.
-- @custEmailAddress: (Optional) The new email address of the customer.
-- @addrCityId: (Optional) The new city ID for the address.
-- @addrPostalCode: (Optional) The new postal code of the address.
-- @addrRegion: (Optional) The new region of the address.
-- @addrStreet: (Optional) The new street of the address.
-- @addrHouseNo: (Optional) The new house number of the address.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_update_customer_and_address 
--     @custId = 123, 
--     @custName = 'John', 
--     @custSurname = 'Doe', 
--     @custPhone = '987654321', 
--     @custEmailAddress = 'john.doe@example.com', 
--     @addrCityId = 456, 
--     @addrPostalCode = '54321', 
--     @addrRegion = 'New Region', 
--     @addrStreet = 'New Street', 
--     @addrHouseNo = '20'
--
-- Result of the action:
-- Customer details or customer address have been successfully changed
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER  PROCEDURE up_update_customer_and_address
    @custId INT,
    @custName VARCHAR(50) = NULL,
    @custSurname VARCHAR(50) = NULL,
    @custPhone VARCHAR(20) = NULL,
    @custEmailAddress VARCHAR(255) = NULL,
    @addrCityId INT = NULL,
    @addrPostalCode VARCHAR(20) = NULL,
    @addrRegion VARCHAR(100) = NULL,
    @addrStreet VARCHAR(255) = NULL,
    @addrHouseNo VARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @addrId INT;

	IF NOT EXISTS (SELECT 1 FROM tbl_customer WHERE custId = @custId)
    BEGIN
        RAISERROR('Customer with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    IF @addrCityId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @addrCityId)
    BEGIN
        RAISERROR('The specified city ID does not exist.', 16, 1);
        RETURN;
    END;

	IF @custEmailAddress IS NOT NULL AND
           @custEmailAddress NOT LIKE '%@%.%' AND
           PATINDEX('%[^a-zA-Z0-9.@]%', @custEmailAddress) <> 0
        BEGIN
            RAISERROR('Invalid email address format.', 16, 1);
            RETURN;
        END;

    SELECT @addrId = custAddrId FROM tbl_customer WHERE custId = @custId;

    IF @addrId IS NOT NULL
    BEGIN
        IF @addrCityId IS NOT NULL
            UPDATE tbl_address SET addrCityId = @addrCityId WHERE addrId = @addrId;
        IF @addrPostalCode IS NOT NULL
            UPDATE tbl_address SET addrPostalCode = @addrPostalCode WHERE addrId = @addrId;
        IF @addrRegion IS NOT NULL
            UPDATE tbl_address SET addrRegion = @addrRegion WHERE addrId = @addrId;
        IF @addrStreet IS NOT NULL
            UPDATE tbl_address SET addrStreet = @addrStreet WHERE addrId = @addrId;
        IF @addrHouseNo IS NOT NULL
            UPDATE tbl_address SET addrHouseNo = @addrHouseNo WHERE addrId = @addrId;
    END;

    IF @custName IS NOT NULL
        UPDATE tbl_customer SET custName = @custName WHERE custId = @custId;
    IF @custSurname IS NOT NULL
        UPDATE tbl_customer SET custSurname = @custSurname WHERE custId = @custId;
    IF @custPhone IS NOT NULL
        UPDATE tbl_customer SET custPhone = @custPhone WHERE custId = @custId;
    IF @custEmailAddress IS NOT NULL
        UPDATE tbl_customer SET custEmailAddress = @custEmailAddress WHERE custId = @custId;

	PRINT 'Customer details or customer address have been successfully changed';
END;