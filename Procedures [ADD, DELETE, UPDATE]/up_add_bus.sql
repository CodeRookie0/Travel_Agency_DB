--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_add_bus
--------------------------------------------------------------------------------------------------
-- This procedure is used to add a new bus to the database.
--
-- Input Parameters:
-- @busNo: The number of the bus to be added (required).
-- @busModel: (Optional) The model of the bus.
-- @busColor: (Optional) The color of the bus.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_add_bus @busNo = '1234', @busModel = 'Mercedes', @busColor = 'Blue'
--
-- Result of the action:
-- The bus was successfully added.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER  PROCEDURE up_add_bus
    @busNo VARCHAR(20),
    @busModel VARCHAR(50),
    @busColor VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

	IF @busNo IS NULL
    BEGIN
        RAISERROR('Bus number cannot be null.', 16, 1);
        RETURN;
    END;

	IF EXISTS (SELECT 1 FROM tbl_bus WHERE busNo = @busNo)
    BEGIN
        RAISERROR('Bus with the specified number already exists.', 16, 1);
        RETURN;
    END;

    INSERT INTO tbl_bus (busNo, busModel, busColor)
    VALUES (@busNo, @busModel, @busColor);
	PRINT 'The bus was successfully added.'
END;
GO