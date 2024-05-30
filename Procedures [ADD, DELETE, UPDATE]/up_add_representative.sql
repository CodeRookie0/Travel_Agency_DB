--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_add_representative
--------------------------------------------------------------------------------------------------
-- This procedure is used to add a new guide to the database.
--
-- Input Parameters:
-- @repName: The name of the representative.
-- @repSurname: The surname of the representative.
-- @repCityId: The city ID where the representative operates.
-- @repPhone: The phone number of the representative.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_add_representative @repName = 'John', @repSurname = 'Doe', @repCityId = 123, @repPhone = '123456789'
--
-- Result of the action:
-- The representative has been successfully added.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_add_representative
    @repName VARCHAR(50),
    @repSurname VARCHAR(50),
    @repCityId INT,
    @repPhone VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
		IF @repName IS NULL OR @repSurname IS NULL OR @repPhone IS NULL
        BEGIN
            RAISERROR('Name, surname, and phone must be provided.', 16, 1);
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @repCityId)
        BEGIN
            RAISERROR('The specified city ID does not exist.', 16, 1);
            RETURN;
        END;

        INSERT INTO tbl_representative (repName, repSurname, repCityId, repPhone)
        VALUES (@repName, @repSurname, @repCityId, @repPhone);

        PRINT 'The representative has been successfully added.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;