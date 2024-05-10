--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_update_hotel_and_address
--------------------------------------------------------------------------------------------------
-- This procedure is used to update the details of a hotel and its address in the database.
--
-- Input Parameters:
-- @hotId: The ID of the hotel to be updated.
-- @hotName: The new name of the hotel. (optional)
-- @hotPricePerNight: The new price per night of the hotel. (optional)
-- @hotTelephoneNo: The new telephone number of the hotel. (optional)
-- @hotContactEmail: The new contact email of the hotel. (optional)
-- @hotStars: The new star rating of the hotel. (optional)
-- @addrCityId: The new city ID of the hotel's address. (optional)
-- @addrPostalCode: The new postal code of the hotel's address. (optional)
-- @addrRegion: The new region of the hotel's address. (optional)
-- @addrStreet: The new street of the hotel's address. (optional)
-- @addrHouseNo: The new house number of the hotel's address. (optional)
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_update_hotel_and_address @hotId = 123, @hotName = 'New Hotel Name', @hotPricePerNight = 150.00
--
-- Result of the action:
-- Hotel details and address have been successfully changed.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_update_hotel_and_address
    @hotId INT,
    @hotName VARCHAR(30) = NULL,
    @hotPricePerNight FLOAT = NULL,
    @hotTelephoneNo VARCHAR(20) = NULL,
    @hotContactEmail VARCHAR(45) = NULL,
    @hotStars INT = NULL,
    @addrCityId INT = NULL,
    @addrPostalCode VARCHAR(20) = NULL,
    @addrRegion VARCHAR(100) = NULL,
    @addrStreet VARCHAR(255) = NULL,
    @addrHouseNo VARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @addrId INT;

    IF NOT EXISTS (SELECT 1 FROM tbl_hotel WHERE hotId = @hotId)
    BEGIN
        RAISERROR('Hotel with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    IF @hotPricePerNight IS NOT NULL AND @hotPricePerNight <= 0
    BEGIN
        RAISERROR('Price per night must be greater than zero.', 16, 1);
        RETURN;
    END;

	IF @hotStars IS NOT NULL AND  @hotStars<= 0 AND  @hotStars > 5
    BEGIN
        RAISERROR('Hotel stars must be greater than zero and less than or equal to five.', 16, 1);
        RETURN;
    END;

    SELECT @addrId = hotAddrId FROM tbl_hotel WHERE hotId = @hotId;

    IF @addrCityId IS NOT NULL OR @addrPostalCode IS NOT NULL OR @addrRegion IS NOT NULL OR @addrStreet IS NOT NULL OR @addrHouseNo IS NOT NULL
    BEGIN
        IF @addrId IS NOT NULL
        BEGIN
            IF @addrCityId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @addrCityId)
            BEGIN
                RAISERROR('City with the specified ID does not exist.', 16, 1);
                RETURN;
            END;

            IF @addrCityId IS NOT NULL AND EXISTS (SELECT 1 FROM tbl_package WHERE packHotId = @hotId)
			BEGIN
                RAISERROR('The hotel is associated with one or more packages and the city of its address cannot be changed.', 16, 1);
                RETURN;
			END;

            UPDATE tbl_address
            SET 
                addrCityId = COALESCE(@addrCityId, addrCityId),
                addrPostalCode = COALESCE(@addrPostalCode, addrPostalCode),
                addrRegion = COALESCE(@addrRegion, addrRegion),
                addrStreet = COALESCE(@addrStreet, addrStreet),
                addrHouseNo = COALESCE(@addrHouseNo, addrHouseNo)
            WHERE addrId = @addrId;

			PRINT 'Hotel address have been successfully changed.';
        END
        ELSE
        BEGIN
            RAISERROR('Address with the specified ID does not exist.', 16, 1);
            RETURN;
        END;
    END;

    IF @hotName IS NOT NULL OR @hotPricePerNight IS NOT NULL OR @hotTelephoneNo IS NOT NULL OR @hotContactEmail IS NOT NULL OR @hotStars IS NOT NULL
    BEGIN
        UPDATE tbl_hotel
        SET 
            hotName = COALESCE(@hotName, hotName),
            hotPricePerNight = COALESCE(@hotPricePerNight, hotPricePerNight),
            hotTelephoneNo = COALESCE(@hotTelephoneNo, hotTelephoneNo),
            hotContactEmail = COALESCE(@hotContactEmail, hotContactEmail),
            hotStars = COALESCE(@hotStars, hotStars)
        WHERE hotId = @hotId;

		PRINT 'Hotel details have been successfully changed.';
    END;
END;
GO