--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_delete_representative
--------------------------------------------------------------------------------------------------
-- This procedure is used to delete a representative from the database.
--
-- Input Parameters:
-- @repId: The ID of the representative to be deleted.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_delete_representative @repId = 123
--
-- Result of the action:
-- The representative has been successfully deleted.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_delete_representative
    @repId INT
AS
BEGIN
    SET NOCOUNT ON;

	IF NOT EXISTS (SELECT 1 FROM tbl_representative WHERE repId = @repId)
    BEGIN
        RAISERROR('The representative with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM tbl_package WHERE packRepId = @repId)
    BEGIN
        RAISERROR('The representative is associated with one or more packages and cannot be deleted.', 16, 1);
        RETURN;
    END;

    DELETE FROM tbl_representative WHERE repId = @repId;

    PRINT 'The representative has been successfully deleted.';
END;
GO