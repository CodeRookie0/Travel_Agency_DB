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
-- Audits the changes made to bus route records, printing the action performed (INSERT, UPDATE, DELETE) 
-- and the affected bus route details.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_busRoute_audit
ON tbl_busroute
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
        DECLARE @driverId INT;
        DECLARE @busRouteStartCityId INT;
        DECLARE @busRouteEndCityId INT;
        DECLARE @busRouteStartTime DATETIME;
        DECLARE @busRouteEndTime DATETIME;
        DECLARE @busRouteBusID INT;
        DECLARE @busRoutePrice DECIMAL(10, 2);

        SELECT @driverId = driverId,
               @busRouteStartCityId = busRouteStartCityId,
               @busRouteEndCityId = busRouteEndCityId,
               @busRouteStartTime = busRouteStartTime,
               @busRouteEndTime = busRouteEndTime,
               @busRouteBusID = busRouteBusID,
               @busRoutePrice = busRoutePrice
        FROM inserted i;

        PRINT '';
        PRINT '--------BUS ROUTE--------';
        PRINT 'driverId : ' + ISNULL(CONVERT(VARCHAR(10), @driverId), '');
        PRINT 'busRouteStartCityId : ' + ISNULL(CONVERT(VARCHAR(10), @busRouteStartCityId), '');
        PRINT 'busRouteEndCityId : ' + ISNULL(CONVERT(VARCHAR(10), @busRouteEndCityId), '');
        PRINT 'busRouteStartTime : ' + ISNULL(CONVERT(VARCHAR(30), @busRouteStartTime, 120), '');
        PRINT 'busRouteEndTime : ' + ISNULL(CONVERT(VARCHAR(30), @busRouteEndTime, 120), '');
        PRINT 'busRouteBusID : ' + ISNULL(CONVERT(VARCHAR(10), @busRouteBusID), '');
        PRINT 'busRoutePrice : ' + ISNULL(CONVERT(VARCHAR(20), @busRoutePrice), '');
        PRINT '';
    END
END;
