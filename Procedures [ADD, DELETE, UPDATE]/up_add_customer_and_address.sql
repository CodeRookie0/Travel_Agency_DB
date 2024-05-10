--------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_add_customer_and_address
--------------------------------------------------------------------------------------
-- This procedure adds a new customer along with their address to the database.
--
-- Input Parameters:
-- @custName: VARCHAR(50) - The first name of the customer.
-- @custSurname: VARCHAR(50) - The last name of the customer.
-- @custPhone: VARCHAR(20) - The phone number of the customer.
-- @custEmailAddress: VARCHAR(255) - The email address of the customer.
-- @cityId: INT - The ID of the city where the customer resides.
-- @addrPostalCode: VARCHAR(20) - The postal code of the customer's address.
-- @addrRegion: VARCHAR(100) - The region of the customer's address.
-- @addrStreet: VARCHAR(255) - The street name of the customer's address.
-- @addrHouseNo: VARCHAR(10) - The house number of the customer's address.
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_add_customer_and_address 'John', 'Doe', '123456789', 'john@example.com', 1, '12345', 'Region', 'Main Street', '10'
--
-- Result of the action
-- The customer and his address have been successfully added.
--------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_add_customer_and_address
    @custName VARCHAR(50),
    @custSurname VARCHAR(50),
    @custPhone VARCHAR(20),
    @custEmailAddress VARCHAR(255),
    @cityId INT = NULL,
    @addrPostalCode VARCHAR(20),
    @addrRegion VARCHAR(100),
    @addrStreet VARCHAR(255),
    @addrHouseNo VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @custName = '' OR @custSurname = '' OR @custPhone = ''
        BEGIN
            RAISERROR('Name, surname, and phone must be provided.', 16, 1);
            RETURN;
        END;

        IF @cityId IS NULL
        BEGIN
            RAISERROR('CityId must be provided.', 16, 1);
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @cityId)
        BEGIN
            RAISERROR('The specified city ID does not exist.', 16, 1);
            RETURN;
        END;

		IF @custEmailAddress IS NOT NULL AND
           @custEmailAddress NOT LIKE '%@%.%' AND
           PATINDEX('%[^a-zA-Z0-9.@]%', @custEmailAddress) <> 0
        BEGIN
            RAISERROR('Invalid email address format.', 16, 1);
            RETURN;
        END;

        IF @addrStreet IS NULL OR @addrHouseNo IS NULL
        BEGIN
            RAISERROR('Address details are incomplete. Please provide street, and house number.', 16, 1);
            RETURN;
        END;

        INSERT INTO tbl_address(addrCityId, addrPostalCode, addrRegion, addrStreet, addrHouseNo)
        VALUES (@cityId, @addrPostalCode, @addrRegion, @addrStreet, @addrHouseNo);

        DECLARE @addrId INT = SCOPE_IDENTITY();

        INSERT INTO tbl_customer(custName, custSurname, custPhone, custEmailAddress, custAddrId)
        VALUES (@custName, @custSurname, @custPhone, @custEmailAddress, @addrId);

		PRINT 'The customer and his address have been successfully added.';
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END