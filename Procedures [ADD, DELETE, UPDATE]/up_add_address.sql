--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_add_address
--------------------------------------------------------------------------------------------------
-- This procedure is used to add a new address to the database.
--
-- Input Parameters:
-- @addrCityId: The ID of the city associated with the address.
-- @addrPostalCode: The postal code of the address.
-- @addrRegion: The region of the address.
-- @addrStreet: The street of the address.
-- @addrHouseNo: The house number of the address.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_add_address @addrCityId = 123, @addrPostalCode = '12345', @addrRegion = 'Region', @addrStreet = 'Street', @addrHouseNo = '10'
--
-- Result of the action:
-- The address has been successfully added.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER  PROCEDURE up_add_address
    @addrCityId INT,
    @addrPostalCode VARCHAR(20),
    @addrRegion VARCHAR(100),
    @addrStreet VARCHAR(255),
    @addrHouseNo VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @addrCityId IS NULL
        BEGIN
            RAISERROR('CityId must be provided.', 16, 1);
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @addrCityId)
        BEGIN
            RAISERROR('The specified city ID does not exist.', 16, 1);
            RETURN;
        END;

        IF @addrStreet IS NULL OR @addrHouseNo IS NULL
        BEGIN
            RAISERROR('Address details are incomplete. Please provide street and house number.', 16, 1);
            RETURN;
        END;

        INSERT INTO tbl_address(addrCityId, addrPostalCode, addrRegion, addrStreet, addrHouseNo)
        VALUES (@addrCityId, @addrPostalCode, @addrRegion, @addrStreet, @addrHouseNo);

        PRINT 'The address has been successfully added.';
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;