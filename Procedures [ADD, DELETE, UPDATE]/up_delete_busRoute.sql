--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_delete_busRoute
--------------------------------------------------------------------------------------------------
-- This procedure is used to delete a bus route from the database.
-- It requires providing the bus route ID as input.
-- If the specified bus route ID does not exist or if the bus route is associated with one or more packages, an error is raised.
-- Otherwise, the bus route is deleted from the database.
--
-- Input Parameters:
-- @busRouteId: The ID of the bus route to be deleted (required).
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_delete_busRoute @busRouteId = 1;
--
-- Result of the action:
-- The bus route has been successfully deleted.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER  PROCEDURE up_delete_busRoute
    @busRouteId INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM tbl_busroute WHERE busRouteId = @busRouteId)
    BEGIN
        RAISERROR('The bus route with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM tbl_package WHERE packOutboundBusRouteId = @busRouteId OR packReturnBusRouteId = @busRouteId)
    BEGIN
        RAISERROR('The bus route is associated with one or more packages and cannot be deleted.', 16, 1);
        RETURN;
    END;

    DELETE FROM  tbl_busroute WHERE busRouteId = @busRouteId;

    PRINT 'The bus route has been successfully deleted.';
END;
GO