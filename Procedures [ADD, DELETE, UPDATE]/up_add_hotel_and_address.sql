--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_add_hotel_and_address
--------------------------------------------------------------------------------------------------
-- This procedure is used to add a new hotel along with its address to the database.
--
-- Input Parameters:
-- @hotName: The name of the hotel.
-- @hotPricePerNight: The price per night for staying at the hotel.
-- @hotTelephoneNo: The telephone number of the hotel.
-- @hotContactEmail: The contact email of the hotel.
-- @hotStars: The star rating of the hotel.
-- @cityId: The ID of the city where the hotel is located.
-- @addrPostalCode: The postal code of the hotel's address.
-- @addrRegion: The region of the hotel's address.
-- @addrStreet: The street of the hotel's address.
-- @addrHouseNo: The house number of the hotel's address.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_add_hotel_and_address 'Example Hotel', 150.00, '123456789', 'example@example.com', 4, 1, '12345', 'Region', 'Main Street', '10'
--
-- Result of the action:
-- The hotel and its address have been successfully added.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_add_hotel_and_address
    @hotName VARCHAR(30),
    @hotPricePerNight FLOAT,
    @hotTelephoneNo VARCHAR(20),
    @hotContactEmail VARCHAR(45),
    @hotStars INT,
    @cityId INT = NULL,
    @addrPostalCode VARCHAR(20),
    @addrRegion VARCHAR(100),
    @addrStreet VARCHAR(255),
    @addrHouseNo VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @hotName IS NULL OR @hotPricePerNight IS NULL
        BEGIN
            RAISERROR('Hotel name and price per night must be provided.', 16, 1);
            RETURN;
        END;

        IF @hotPricePerNight <= 0
        BEGIN
            RAISERROR('Price per night must be greater than zero.', 16, 1);
            RETURN
        END;

		IF @hotStars IS NOT NULL AND  @hotStars<= 0 AND  @hotStars > 5
        BEGIN
            RAISERROR('Hotel stars must be greater than zero and less than or equal to five.', 16, 1);
            RETURN;
        END;

        IF @cityId IS NULL
        BEGIN
            RAISERROR('CityId must be provided.', 16, 1);
            RETURN;;
        END;

        IF NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @cityId)
        BEGIN
            RAISERROR('The specified city ID does not exist.', 16, 1);
            RETURN;
        END;

        IF @addrStreet IS NULL OR @addrHouseNo IS NULL
        BEGIN
            RAISERROR('Address details are incomplete. Please provide street, and house number.', 16, 1);
            RETURN;
        END;

		DECLARE @addrId INT;

        INSERT INTO tbl_address(addrCityId, addrPostalCode, addrRegion, addrStreet, addrHouseNo)
        VALUES (@cityId, @addrPostalCode, @addrRegion, @addrStreet, @addrHouseNo);

        SET @addrId = SCOPE_IDENTITY();

        INSERT INTO tbl_hotel(hotAddrId, hotName, hotPricePerNight, hotTelephoneNo, hotContactEmail, hotStars)
        VALUES (@addrId, @hotName, @hotPricePerNight, @hotTelephoneNo, @hotContactEmail, @hotStars);

        PRINT 'The hotel and its address have been successfully added.';
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;
GO