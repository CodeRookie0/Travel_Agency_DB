--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_update_bus
--------------------------------------------------------------------------------------------------
-- This procedure is used to update the details of a bus in the database.
-- It requires providing the ID of the bus to be updated and optionally the new values for its attributes.
-- If the bus with the specified ID does not exist, an error is raised.
-- If a new bus number is provided and it already exists for another bus, an error is raised.
--
-- Input Parameters:
-- @busId: The ID of the bus to be updated (required).
-- @busNo: The new number of the bus (optional).
-- @busModel: The new model of the bus (optional).
-- @busColor: The new color of the bus (optional).
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_update_bus @busId = 123, @busNo = 'ABC1234', @busModel = 'Model X'
--
-- Result of the action:
-- The details of the bus have been successfully updated.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER  PROCEDURE up_update_bus
    @busId INT,
    @busNo VARCHAR(20) = NULL,
    @busModel VARCHAR(50) = NULL,
    @busColor VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM tbl_bus WHERE busId = @busId)
    BEGIN
        RAISERROR('The bus with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    IF @busNo IS NOT NULL AND EXISTS (SELECT 1 FROM tbl_bus WHERE busNo = @busNo AND busId != @busId)
    BEGIN
        RAISERROR('The bus number specified already exists.', 16, 1);
        RETURN;
    END;

    UPDATE tbl_bus
    SET 
        busNo = CASE WHEN @busNo IS NOT NULL THEN @busNo ELSE busNo END,
        busModel = CASE WHEN @busModel IS NOT NULL THEN @busModel ELSE busModel END,
        busColor = CASE WHEN @busColor IS NOT NULL THEN @busColor ELSE busColor END
    WHERE busId = @busId;
END;
GO