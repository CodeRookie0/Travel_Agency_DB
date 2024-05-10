--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_update_address
--------------------------------------------------------------------------------------------------
-- This procedure is used to update the details of an existing address in the database.
--
-- Input Parameters:
-- @addrId: The ID of the address to be updated.
-- @addrCityId: The ID of the city associated with the address (optional).
-- @addrPostalCode: The postal code of the address (optional).
-- @addrRegion: The region of the address (optional).
-- @addrStreet: The street of the address (optional).
-- @addrHouseNo: The house number of the address (optional).
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_update_address @addrId = 123, @addrCityId = 456, @addrPostalCode = '12345', @addrRegion = 'Region', @addrStreet = 'Street', @addrHouseNo = '10'
--
-- Result of the action:
-- Address details have been successfully modified.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER  PROCEDURE up_update_address
    @addrId INT,
    @addrCityId INT = NULL,
    @addrPostalCode VARCHAR(20) = NULL,
    @addrRegion VARCHAR(100) = NULL,
    @addrStreet VARCHAR(255) = NULL,
    @addrHouseNo VARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM tbl_address WHERE addrId = @addrId)
    BEGIN
        RAISERROR('Address with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    IF @addrCityId IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @addrCityId)
        BEGIN
            RAISERROR('The specified city ID does not exist.', 16, 1);
            RETURN;
        END;

		IF EXISTS (SELECT 1 FROM tbl_package WHERE packHotId IN (SELECT hotId FROM tbl_hotel WHERE hotAddrId = @addrId))
		BEGIN
			RAISERROR('This address is associated with one or more hotels, which are associated with one or more packages. At this moment, it is not possible to change the city of this address.', 16, 1);
			RETURN;
		END;
    END;

    UPDATE tbl_address
    SET 
        addrCityId = COALESCE(@addrCityId, addrCityId),
        addrPostalCode = COALESCE(@addrPostalCode, addrPostalCode),
        addrRegion = COALESCE(@addrRegion, addrRegion),
        addrStreet = COALESCE(@addrStreet, addrStreet),
        addrHouseNo = COALESCE(@addrHouseNo, addrHouseNo)
    WHERE addrId = @addrId;
    PRINT 'Address details have been successfully modified.';
END;
GO