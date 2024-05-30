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
-- Audits the changes made to address records, adding records to the tbl_address_archive table with an indication of the action performed (INSERT, UPDATE, DELETE) 
-- and including the affected address details.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_address_audit
ON tbl_address
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Action CHAR(1);

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        SET @Action = 'U';
    END
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN
        SET @Action = 'I';
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        SET @Action = 'D';
    END

    IF @Action IN ('I', 'U')
    BEGIN
        INSERT INTO tbl_address_archive (archiveAction, addrId, addrCityId, addrPostalCode, addrRegion, addrStreet, addrHouseNo, archivedAt)
        SELECT 
            @Action,
            addrId,
            addrCityId,
            addrPostalCode,
            addrRegion,
            addrStreet,
            addrHouseNo,
            GETDATE()
        FROM inserted;
    END

	IF @Action = 'D'
    BEGIN
        INSERT INTO tbl_address_archive (archiveAction, addrId, addrCityId, addrPostalCode, addrRegion, addrStreet, addrHouseNo, archivedAt)
        SELECT 
            @Action,
            addrId,
            addrCityId,
            addrPostalCode,
            addrRegion,
            addrStreet,
            addrHouseNo,
            GETDATE()
        FROM deleted;
    END
END;