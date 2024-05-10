--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_add_guide
--------------------------------------------------------------------------------------------------
-- This procedure is used to add a new guide to the database.
--
-- Input Parameters:
-- @guideName: The name of the guide.
-- @guideSurname: The surname of the guide.
-- @guideCityId: The city ID where the guide operates.
-- @guidePhone: The phone number of the guide.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_add_guide @guideName = 'John', @guideSurname = 'Doe', @guideCityId = 123, @guidePhone = '123456789'
--
-- Result of the action:
-- The guide has been successfully added.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_add_guide
    @guideName VARCHAR(50),
    @guideSurname VARCHAR(50),
    @guideCityId INT,
    @guidePhone VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
		IF @guideName IS NULL OR @guideSurname IS NULL OR @guidePhone IS NULL
        BEGIN
            RAISERROR('Name, surname, and phone must be provided.', 16, 1);
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @guideCityId)
        BEGIN
            RAISERROR('The specified city ID does not exist.', 16, 1);
            RETURN;
        END;

        INSERT INTO tbl_guide(guideName, guideSurname, guideCityId, guidePhone)
        VALUES (@guideName, @guideSurname, @guideCityId, @guidePhone);

        PRINT 'The guide has been successfully added.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;