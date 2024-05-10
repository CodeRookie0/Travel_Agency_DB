--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_delete_guide
--------------------------------------------------------------------------------------------------
-- This procedure is used to delete a guide from the database.
--
-- Input Parameters:
-- @guideId: The ID of the guide to be deleted.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_delete_guide @guideId = 123
--
-- Result of the action:
-- The guide has been successfully deleted.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_delete_guide
    @guideId INT
AS
BEGIN
    SET NOCOUNT ON;

	IF NOT EXISTS (SELECT 1 FROM tbl_guide WHERE guideId = @guideId)
    BEGIN
        RAISERROR('The guide with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM tbl_package WHERE packGuideId = @guideId)
    BEGIN
        RAISERROR('The guide is associated with one or more packages and cannot be deleted.', 16, 1);
        RETURN;
    END;

    DELETE FROM tbl_guide WHERE guideId = @guideId;

    PRINT 'The guide has been successfully deleted.';
END;
GO