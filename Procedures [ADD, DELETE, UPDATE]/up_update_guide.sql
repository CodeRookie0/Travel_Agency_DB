--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_update_guide
--------------------------------------------------------------------------------------------------
-- This procedure is used to update the details of a guide in the database.
--
-- Input Parameters:
-- @guideId: The ID of the guide to be updated.
-- @guideName: (Optional) The new name of the guide.
-- @guideSurname: (Optional) The new surname of the guide.
-- @guideCityId: (Optional) The new city ID of the guide.
-- @guidePhone: (Optional) The new phone number of the guide.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_update_guide @guideId = 123, @guideName = 'John', @guideSurname = 'Doe', @guideCityId = 1, @guidePhone = '123456789'
--
-- Result of the action:
-- Guide data was changed successfully.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_update_guide
    @guideId INT,
    @guideName VARCHAR(50) = NULL,
    @guideSurname VARCHAR(50) = NULL,
    @guideCityId INT = NULL,
    @guidePhone VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM tbl_guide WHERE guideId = @guideId)
    BEGIN
        RAISERROR('The guide with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    IF @guideCityId IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @guideCityId)
        BEGIN
            RAISERROR('The specified city ID does not exist.', 16, 1);
            RETURN;
        END;

		IF EXISTS (SELECT 1 FROM tbl_package WHERE packGuideId = @guideId)
		BEGIN
			RAISERROR('This guide is associated with one or more packages. The city cannot be changed because one or more packages are related to this city and this city''s guide.', 16, 1);
			RETURN;
		END;
    END;

    UPDATE tbl_guide
    SET 
        guideName = COALESCE(@guideName, guideName),
        guideSurname = COALESCE(@guideSurname, guideSurname),
        guideCityId = COALESCE(@guideCityId, guideCityId),
        guidePhone = COALESCE(@guidePhone, guidePhone)
    WHERE guideId = @guideId;

	PRINT 'Guide data was changed successfully';
END;
GO