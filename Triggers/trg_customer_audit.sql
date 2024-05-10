---------------------------------------------------------------
--- TRIGGER DEFINITION
--- trg_customer_audit
---------------------------------------------------------------
-- This trigger is designed to audit changes made to the tbl_customer table, including INSERT, UPDATE, 
-- and DELETE operations.
--
-- Trigger Events:
-- AFTER INSERT, UPDATE, DELETE
--
-- Result of the action:
-- Audits the changes made to customer records, printing the action performed (INSERT, UPDATE, DELETE) 
-- and the affected customer and address details.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_customer_audit
ON tbl_customer
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Action NVARCHAR(10);
	
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        SET @Action = 'UPDATE';
    END
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN
        SET @Action = 'INSERT';
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        SET @Action = 'DELETE';
    END

    PRINT 'Action: ' + @Action;

    IF @Action IN ('INSERT', 'UPDATE')
    BEGIN
        DECLARE @custName VARCHAR(50);
        DECLARE @custSurname VARCHAR(50);
        DECLARE @custPhone VARCHAR(20);
        DECLARE @custEmailAddress VARCHAR(255);
        DECLARE @cityId INT;
        DECLARE @addrPostalCode VARCHAR(20);
        DECLARE @addrRegion VARCHAR(100);
        DECLARE @addrStreet VARCHAR(255);
        DECLARE @addrHouseNo VARCHAR(10);

        SELECT @custName = custName,
               @custSurname = custSurname,
               @custPhone = custPhone,
               @custEmailAddress = custEmailAddress,
               @cityId = a.addrCityId,
               @addrPostalCode = a.addrPostalCode,
               @addrRegion = a.addrRegion,
               @addrStreet = a.addrStreet,
               @addrHouseNo = a.addrHouseNo
        FROM inserted i
        INNER JOIN tbl_address a ON i.custAddrId = a.addrId;
		
        PRINT '';
        PRINT '--------CUSTOMER--------';
        PRINT 'custName : ' + ISNULL(@custName, '');
        PRINT 'custSurname : ' + ISNULL(@custSurname, '');
        PRINT 'custPhone : ' + ISNULL(@custPhone, '');
        PRINT 'custEmailAddress : ' + ISNULL(@custEmailAddress, '');
        PRINT '';
        PRINT '--------ADDRESS--------';
        PRINT 'cityId : ' + ISNULL(CONVERT(VARCHAR(10), @cityId), '');
        PRINT 'addrPostalCode : ' + ISNULL(@addrPostalCode, '');
        PRINT 'addrRegion : ' + ISNULL(@addrRegion, '');
        PRINT 'addrStreet : ' + ISNULL(@addrStreet, '');
        PRINT 'addrHouseNo : ' + ISNULL(@addrHouseNo, '');
        PRINT '';
    END
END;
