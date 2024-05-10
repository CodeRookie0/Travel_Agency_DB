--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_delete_bus
--------------------------------------------------------------------------------------------------
-- This procedure is used to delete a bus from the database.
-- It requires providing the ID of the bus to be deleted.
-- If the bus with the specified ID does not exist or is associated with a route, an error is raised.
--
-- Input Parameters:
-- @busId: The ID of the bus to be deleted (required).
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_delete_bus @busId = 123
--
-- Result of the action:
-- The bus has been successfully deleted.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER  PROCEDURE up_delete_bus
    @busId INT
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @isAssociatedWithRoute BIT;

    IF NOT EXISTS (SELECT 1 FROM tbl_bus WHERE busId = @busId)
    BEGIN
        RAISERROR('The bus with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    SELECT @isAssociatedWithRoute = CASE
           WHEN EXISTS (SELECT 1 FROM tbl_busroute WHERE busRouteBusID = @busId) THEN 1
           ELSE 0
       END;

    IF @isAssociatedWithRoute = 1
    BEGIN
        RAISERROR('The bus is associated with one or more routes and cannot be deleted.', 16, 1);
        RETURN;
    END;

    DELETE FROM tbl_bus WHERE busId = @busId;

    PRINT 'The bus has been successfully deleted.';
END;
GO
