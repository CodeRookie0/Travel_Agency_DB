--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_update_representative
--------------------------------------------------------------------------------------------------
-- This procedure is used to update the details of a representative in the database.
--
-- Input Parameters:
-- @repId: The ID of the representative to be updated.
-- @repName: (Optional) The new name of the representative.
-- @grepSurname: (Optional) The new surname of the representative.
-- @repCityId: (Optional) The new city ID of the representative.
-- @repPhone: (Optional) The new phone number of the representative.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_update_representative @repId = 123, @repName = 'John', @repSurname = 'Doe', @repCityId = 1, @repPhone = '123456789'
--
-- Result of the action:
-- Representative data was changed successfully.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_update_representative
    @repId INT,
    @repName VARCHAR(50) = NULL,
    @repSurname VARCHAR(50) = NULL,
    @repCityId INT = NULL,
    @repPhone VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM tbl_representative WHERE repId = @repId)
    BEGIN
        RAISERROR('The representative with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    IF @repCityId IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @repCityId)
        BEGIN
            RAISERROR('The specified city ID does not exist.', 16, 1);
            RETURN;
        END;

		IF EXISTS (SELECT 1 FROM tbl_package WHERE packRepId = @repId)
		BEGIN
			RAISERROR('This representative is associated with one or more packages. The city cannot be changed because one or more packages are related to this city and this city''s representative.', 16, 1);
			RETURN;
		END;
    END;

    UPDATE tbl_representative
    SET 
        repName = COALESCE(@repName, repName),
        repSurname = COALESCE(@repSurname, repSurname),
        repCityId = COALESCE(@repCityId, repCityId),
        repPhone = COALESCE(@repPhone, repPhone)
    WHERE repId = @repId;

	PRINT 'Representative data was changed successfully';
END;
GO