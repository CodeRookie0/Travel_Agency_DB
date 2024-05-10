---------------------------------------------------------------
--- TRIGGER DEFINITION
--- trg_address_audit
---------------------------------------------------------------
-- This trigger is designed to audit changes made to the tbl_address table, including INSERT, UPDATE, 
-- and DELETE operations.
--
-- Trigger Events:
-- AFTER INSERT, UPDATE, DELETE
--
-- Result of the action:
-- Audits the changes made to address records, printing the action performed (INSERT, UPDATE, DELETE) 
-- and the affected address details.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_address_audit
ON tbl_address
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
        DECLARE @addrCityId INT;
        DECLARE @addrPostalCode VARCHAR(20);
        DECLARE @addrRegion VARCHAR(100);
        DECLARE @addrStreet VARCHAR(255);
        DECLARE @addrHouseNo VARCHAR(10);

        SELECT @addrCityId = addrCityId,
               @addrPostalCode = addrPostalCode,
               @addrRegion = addrRegion,
               @addrStreet = addrStreet,
               @addrHouseNo = addrHouseNo
        FROM inserted i;

        PRINT '';
        PRINT '--------ADDRESS--------';
        PRINT 'addrCityId : ' + ISNULL(CONVERT(VARCHAR(10), @addrCityId), '');
        PRINT 'addrPostalCode : ' + ISNULL(@addrPostalCode, '');
        PRINT 'addrRegion : ' + ISNULL(@addrRegion, '');
        PRINT 'addrStreet : ' + ISNULL(@addrStreet, '');
        PRINT 'addrHouseNo : ' + ISNULL(@addrHouseNo, '');
        PRINT '';
    END
END;