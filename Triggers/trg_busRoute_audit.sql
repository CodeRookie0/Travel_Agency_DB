---------------------------------------------------------------
--- TRIGGER DEFINITION
--- trg_busRoute_audit
---------------------------------------------------------------
-- This trigger is designed to audit changes made to the tbl_busroute table, including INSERT, UPDATE, 
-- and DELETE operations.
--
-- Trigger Events:
-- AFTER INSERT, UPDATE, DELETE
--
-- Result of the action:
-- Audits the changes made to bus route records, adding records to the tbl_busroute_archive table with an indication of the action performed (INSERT, UPDATE, DELETE) 
-- and including the affected bus route details.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_busRoute_audit
ON tbl_busroute
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
        INSERT INTO tbl_busroute_archive (archiveAction, busRouteId, driverId, busRouteStartCityId, busRouteEndCityId, busRouteStartTime, busRouteEndTime, busRouteBusID, busRoutePrice, archivedAt)
        SELECT 
            @Action,
            busRouteId,
            driverId,
            busRouteStartCityId,
            busRouteEndCityId,
            busRouteStartTime,
            busRouteEndTime,
            busRouteBusID,
            busRoutePrice,
            GETDATE()
        FROM inserted;
    END

	IF @Action = 'D'
    BEGIN
        INSERT INTO tbl_busroute_archive (archiveAction, busRouteId, driverId, busRouteStartCityId, busRouteEndCityId, busRouteStartTime, busRouteEndTime, busRouteBusID, busRoutePrice, archivedAt)
        SELECT 
            @Action,
            busRouteId,
            driverId,
            busRouteStartCityId,
            busRouteEndCityId,
            busRouteStartTime,
            busRouteEndTime,
            busRouteBusID,
            busRoutePrice,
            GETDATE()
        FROM deleted;
    END
END;
