---------------------------------------------------------------
--- TRIGGER DEFINITION
--- trg_package_modify_audit
---------------------------------------------------------------
-- This trigger is designed to calculate package details after INSERT or UPDATE operations on the tbl_package table.
--
-- Trigger Events:
-- AFTER INSERT, UPDATE
--
-- Result of the action:
-- Calls the stored procedure up_calculate_package_details to update package details based on the inserted or updated data,
-- and inserts a record into the tbl_package_archive table.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_package_modify_audit 
ON tbl_package
AFTER INSERT,UPDATE
AS
BEGIN
    DECLARE @packId INT
    DECLARE @packHotId INT
    DECLARE @packOutboundFlightId INT
    DECLARE @packReturnFlightId INT
    DECLARE @packOutboundBusRouteId INT
    DECLARE @packReturnBusRouteId INT
	DECLARE @ActionType CHAR(1)

	SET @ActionType = CASE 
          WHEN EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) THEN 'U'
          WHEN EXISTS (SELECT * FROM inserted) THEN 'I'
          ELSE NULL
      END;

	IF @ActionType = 'U'
    BEGIN
        IF NOT EXISTS (
            SELECT *
            FROM inserted i
            INNER JOIN deleted d ON i.packId = d.packId
            WHERE 
                i.packTitle <> d.packTitle OR
                i.packCityId <> d.packCityId OR
                i.packHotId <> d.packHotId OR
                i.packDuration <> d.packDuration OR
                i.packPrice <> d.packPrice OR
                i.packStartDate <> d.packStartDate OR
                i.packEndDate <> d.packEndDate OR
                i.packOutboundFlightId <> d.packOutboundFlightId OR
                i.packReturnFlightId <> d.packReturnFlightId OR
                i.packOutboundBusRouteId <> d.packOutboundBusRouteId OR
                i.packReturnBusRouteId <> d.packReturnBusRouteId OR
                i.packRepId <> d.packRepId OR
                i.packMinCapacity <> d.packMinCapacity OR
                i.packMaxCapacity <> d.packMaxCapacity OR
                i.packCurrentBookings <> d.packCurrentBookings
        )
        BEGIN
            RETURN;
        END;
    END;

	INSERT INTO tbl_package_archive (archiveAction, packId, packTitle, packCityId, packHotId, packDuration, packPrice, packStartDate, packEndDate, packOutboundFlightId, packReturnFlightId, packOutboundBusRouteId, packReturnBusRouteId, packRepId, packMinCapacity, packMaxCapacity, packCurrentBookings, wasRealized, archivedAt)
    SELECT 
        @ActionType,
        COALESCE(i.packId, d.packId),
        COALESCE(i.packTitle, d.packTitle),
        COALESCE(i.packCityId, d.packCityId),
        COALESCE(i.packHotId, d.packHotId),
        COALESCE(i.packDuration, d.packDuration),
        COALESCE(i.packPrice, d.packPrice),
        COALESCE(i.packStartDate, d.packStartDate),
        COALESCE(i.packEndDate, d.packEndDate),
        COALESCE(i.packOutboundFlightId, d.packOutboundFlightId),
        COALESCE(i.packReturnFlightId, d.packReturnFlightId),
        COALESCE(i.packOutboundBusRouteId, d.packOutboundBusRouteId),
        COALESCE(i.packReturnBusRouteId, d.packReturnBusRouteId),
        COALESCE(i.packRepId, d.packRepId),
        COALESCE(i.packMinCapacity, d.packMinCapacity),
        COALESCE(i.packMaxCapacity, d.packMaxCapacity),
        COALESCE(i.packCurrentBookings, d.packCurrentBookings),
        NULL,
        GETDATE()
    FROM inserted i
    FULL OUTER JOIN deleted d ON i.packId = d.packId;
END