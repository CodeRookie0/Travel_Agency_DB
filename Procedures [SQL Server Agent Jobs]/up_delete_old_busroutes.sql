--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_delete_old_busroutes
--------------------------------------------------------------------------------------------------
-- This procedure is used to delete old bus routes from the database.
-- Bus routes with end times earlier than the current date will be removed.
--
-- Example Usage:
-- EXEC up_delete_old_busroutes
--
-- Result of the action:
-- Old bus routes with end times before the current date were successfully deleted.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_delete_old_busroutes
AS
BEGIN
    DELETE FROM tbl_busroute
    WHERE busRouteEndTime < GETDATE();
END
GO
