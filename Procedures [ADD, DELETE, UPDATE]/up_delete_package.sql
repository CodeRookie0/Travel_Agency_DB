--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_delete_package
--------------------------------------------------------------------------------------------------
-- This procedure is used to delete a package from the database.
-- The procedure first checks if the package ID exists and whether the package is associated with any bookings.
-- If the package is associated with bookings, it cannot be deleted, and an error is raised.
-- Otherwise, the package is deleted from the database.
--
-- Input Parameters:
-- @packId: The ID of the package to be deleted (required).
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_delete_package @packId = 1;
--
-- Result of the action:
-- The package has been successfully deleted.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_delete_package
    @packId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @confirmation CHAR(1);

    IF NOT EXISTS (SELECT 1 FROM tbl_package WHERE packId = @packId)
    BEGIN
        RAISERROR('The specified package ID does not exist.', 16, 1);
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM tbl_booking WHERE bookPackageId = @packId)
    BEGIN
        RAISERROR('The package is associated with one or more bookings and cannot be deleted.', 16, 1);
        RETURN;
    END;

    DELETE FROM tbl_package WHERE packId = @packId;

    PRINT 'The package has been successfully deleted.';
END;
GO
