---------------------------------------------------------------
--- TRIGGER DEFINITION
--- trg_hotel_audit
---------------------------------------------------------------
-- This trigger is designed to audit changes made to the tbl_hotel table, including INSERT, UPDATE, 
-- and DELETE operations.
--
-- Trigger Events:
-- AFTER INSERT, UPDATE, DELETE
--
-- Result of the action:
-- Audits the changes made to hotel records, printing the action performed (INSERT, UPDATE, DELETE) 
-- and the affected hotel and address details.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_hotel_audit
ON tbl_hotel
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
        DECLARE @hotName VARCHAR(50);
        DECLARE @hotPricePerNight DECIMAL(10, 2);
        DECLARE @hotTelephoneNo VARCHAR(20);
        DECLARE @hotContactEmail VARCHAR(45);
        DECLARE @hotStars INT;
        DECLARE @cityId INT;
        DECLARE @addrPostalCode VARCHAR(20);
        DECLARE @addrRegion VARCHAR(100);
        DECLARE @addrStreet VARCHAR(255);
        DECLARE @addrHouseNo VARCHAR(10);

        SELECT @hotName = hotName,
               @hotPricePerNight = hotPricePerNight,
               @hotTelephoneNo = hotTelephoneNo,
               @hotContactEmail = hotContactEmail,
               @hotStars = hotStars,
               @cityId = a.addrCityId,
               @addrPostalCode = a.addrPostalCode,
               @addrRegion = a.addrRegion,
               @addrStreet = a.addrStreet,
               @addrHouseNo = a.addrHouseNo
        FROM inserted i
        INNER JOIN tbl_address a ON i.hotAddrId = a.addrId;

        PRINT '';
        PRINT '--------HOTEL--------';
        PRINT 'hotName : ' + ISNULL(@hotName, '');
        PRINT 'hotPricePerNight : ' + ISNULL(CONVERT(VARCHAR(20), @hotPricePerNight), '');
        PRINT 'hotTelephoneNo : ' + ISNULL(@hotTelephoneNo, '');
        PRINT 'hotContactEmail : ' + ISNULL(@hotContactEmail, '');
        PRINT 'hotStars : ' + ISNULL(CONVERT(VARCHAR(10), @hotStars), '');
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