---------------------------------------------------------------
--- TRIGGER DEFINITION
--- trg_calculate_package_details
---------------------------------------------------------------
-- This trigger is designed to calculate package details after INSERT or UPDATE operations on the tbl_package table.
--
-- Trigger Events:
-- AFTER INSERT, UPDATE
--
-- Result of the action:
-- Calls the stored procedure up_calculate_package_details to update package details based on the inserted or updated data.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_calculate_package_details 
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

    SELECT @packId = packId,
		   @packHotId = packHotId,
           @packOutboundFlightId = packOutboundFlightId,
           @packReturnFlightId = packReturnFlightId,
           @packOutboundBusRouteId = packOutboundBusRouteId,
           @packReturnBusRouteId = packReturnBusRouteId
    FROM inserted

    EXEC up_calculate_package_details @packId, @packHotId, @packOutboundFlightId, @packReturnFlightId, @packOutboundBusRouteId, @packReturnBusRouteId
END