---------------------------------------------------------------
--- TRIGGER DEFINITION
--- trg_flight_audit
---------------------------------------------------------------
-- This trigger is designed to audit changes made to the tbl_flight table, including INSERT, UPDATE, 
-- and DELETE operations.
--
-- Trigger Events:
-- AFTER INSERT, UPDATE, DELETE
--
-- Result of the action:
-- Audits the changes made to flight records, adding records to the tbl_flight_archive table with an indication of the action performed (INSERT, UPDATE, DELETE) 
-- and including the affected flight details.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_flight_audit
ON tbl_flight
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
        INSERT INTO tbl_flight_archive (archiveAction, fliId, fliStartCityId, fliEndCityId, fliStartTime, fliEndTime, fliClass, fliPrice, archivedAt)
        SELECT 
            @Action,
            fliId,
            fliStartCityId,
            fliEndCityId,
            fliStartTime,
            fliEndTime,
            fliClass,
            fliPrice,
            GETDATE()
        FROM inserted;
    END

    IF @Action = 'D'
    BEGIN
        INSERT INTO tbl_flight_archive (archiveAction, fliId, fliStartCityId, fliEndCityId, fliStartTime, fliEndTime, fliClass, fliPrice, archivedAt)
        SELECT 
            @Action,
            fliId,
            fliStartCityId,
            fliEndCityId,
            fliStartTime,
            fliEndTime,
            fliClass,
            fliPrice,
            GETDATE()
        FROM deleted;
    END
END;