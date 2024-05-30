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
-- Audits the changes made to hotel records, adding records to the tbl_hotel_archive table with an indication of the action performed (INSERT, UPDATE, DELETE) 
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_hotel_audit
ON tbl_hotel
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
        INSERT INTO tbl_hotel_archive (archiveAction, hotId, hotAddrId, hotName, hotPricePerNight, hotTelephoneNo, hotContactEmail, hotStars, archivedAt)
        SELECT 
            @Action,
            hotId,
            hotAddrId,
            hotName,
            hotPricePerNight,
            hotTelephoneNo,
            hotContactEmail,
            hotStars,
            GETDATE()
        FROM inserted;
    END

	IF @Action = 'D'
    BEGIN
        INSERT INTO tbl_hotel_archive (archiveAction, hotId, hotAddrId, hotName, hotPricePerNight, hotTelephoneNo, hotContactEmail, hotStars, archivedAt)
        SELECT 
            @Action,
            hotId,
            hotAddrId,
            hotName,
            hotPricePerNight,
            hotTelephoneNo,
            hotContactEmail,
            hotStars,
            GETDATE()
        FROM deleted;
    END
END;