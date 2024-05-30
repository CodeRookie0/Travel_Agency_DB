---------------------------------------------------------------
--- TRIGGER DEFINITION
--- trg_package_delete_audit
---------------------------------------------------------------
-- This trigger is designed to audit DELETE operations on the tbl_package table.
--
-- Trigger Events:
-- AFTER DELETE
--
-- Result of the action:
-- Inserts deleted records into tbl_package_archive with an indication of whether the package was realized.
---------------------------------------------------------------
USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_package_delete_audit
ON tbl_package
AFTER DELETE
AS
BEGIN
	DECLARE @wasRealized BIT;

	SELECT @wasRealized = 
        CASE 
            WHEN packCurrentBookings >= packMinCapacity AND packStartDate < GETDATE() THEN 1
            WHEN packCurrentBookings < packMinCapacity AND packStartDate < GETDATE() THEN 0
            ELSE NULL
        END
    FROM deleted;

    INSERT INTO tbl_package_archive (archiveAction, packId, packTitle, packCityId, packHotId, packDuration, packPrice, packStartDate, packEndDate, packOutboundFlightId, packReturnFlightId, packOutboundBusRouteId, packReturnBusRouteId, packRepId, packMinCapacity, packMaxCapacity, packCurrentBookings, wasRealized, archivedAt)
    SELECT 'D', 
           packId, 
           packTitle,
           packCityId, 
           packHotId, 
           packDuration, 
           packPrice, 
           packStartDate, 
           packEndDate, 
           packOutboundFlightId, 
           packReturnFlightId, 
           packOutboundBusRouteId, 
           packReturnBusRouteId, 
           packRepId, 
           packMinCapacity, 
           packMaxCapacity, 
           packCurrentBookings, 
           @wasRealized,
           GETDATE()
    FROM deleted;
END;