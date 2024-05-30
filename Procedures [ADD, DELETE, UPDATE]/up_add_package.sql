--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_add_package
--------------------------------------------------------------------------------------------------
-- This procedure is used to add a new package to the database.
-- It ensures consistency between the package details and the associated entities, such as verifying that the hotel and representative are in the same city as the package.
-- The procedure also checks for the existence of outbound and return flights or bus routes, requiring both to be specified.
-- Additionally, it calculates the start and end dates of the package based on the provided flights or bus routes and verifies that the duration is between 3 and 30 days.
--
-- Input Parameters:
-- @packTitle: The title of the package (required).
-- @packDescription: The description of the package.
-- @packCityId: The ID of the city where the package is offered (required).
-- @packHotId: The ID of the hotel associated with the package (required).
-- @packOutboundFlightId: The ID of the outbound flight associated with the package (optional).
-- @packReturnFlightId: The ID of the return flight associated with the package (optional).
-- @packOutboundBusRouteId: The ID of the outbound bus route associated with the package (optional).
-- @packReturnBusRouteId: The ID of the return bus route associated with the package (optional).
-- @packRepId: The ID of the representative associated with the package (required).
-- @packMaxCapacity: The maximum capacity of the package (optional, default = 40).
-- @packMinCapacity: The minimum capacity of the package (optional, default = 10).
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_add_package @packTitle = 'Summer Vacation', @packDescription = 'Enjoy a relaxing summer vacation by the beach.', 
--                     @packCityId = 2, @packHotId = 4, @packOutboundFlightId = 201, @packReturnFlightId = 202, @packRepId = 2,
--                     @packMaxCapacity = 70, @packMinCapacity = 25;
--
-- Result of the action:
-- The package has been successfully added.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_add_package
    @packTitle VARCHAR(30),
    @packDescription TEXT,
    @packCityId INT,
    @packHotId INT,
    @packOutboundFlightId INT = NULL,
    @packReturnFlightId INT = NULL,
    @packOutboundBusRouteId INT = NULL,
    @packReturnBusRouteId INT = NULL,
    @packRepId INT,
    @packMaxCapacity INT = NULL,
    @packMinCapacity INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF LEN(@packTitle) = 0
    BEGIN
        RAISERROR('Package title cannot be empty.', 16, 1);
        RETURN;
    END;

	IF NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @packCityId)
    BEGIN
        RAISERROR('The specified city ID does not exist.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM tbl_hotel WHERE hotId = @packHotId)
    BEGIN
        RAISERROR('The specified hotel ID does not exist.', 16, 1);
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM tbl_hotel AS H
        INNER JOIN tbl_address AS A ON H.hotAddrId = A.addrId
        WHERE H.hotId = @packHotId AND A.addrCityId <> @packCityId
    )
    BEGIN
        RAISERROR('The city of the specified hotel does not match the package city.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM tbl_representative WHERE repId = @packRepId)
    BEGIN
        RAISERROR('The specified representative ID does not exist.', 16, 1);
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM tbl_representative AS R
        INNER JOIN tbl_city AS C ON R.repCityId = C.cityId
        WHERE R.repId = @packRepId AND C.cityId <> @packCityId
    )
    BEGIN
        RAISERROR('The city of the specified representative does not match the package city.', 16, 1);
        RETURN;
    END;

	IF (@packOutboundFlightId IS NULL AND @packReturnFlightId IS NOT NULL) OR (@packOutboundBusRouteId  IS NOT NULL AND @packReturnBusRouteId  IS NULL)
    BEGIN
        RAISERROR('You need to add either a flight or a bus route.', 16, 1);
        RETURN;
    END;

	IF (@packOutboundFlightId IS NOT NULL AND @packReturnFlightId IS NULL) OR (@packOutboundBusRouteId  IS NULL AND @packReturnBusRouteId  IS NOT NULL)
    BEGIN
        RAISERROR('You need to add either a flight or a bus route.', 16, 1);
        RETURN;
    END;
	
	IF (@packOutboundFlightId IS NOT NULL AND @packReturnFlightId IS NULL) OR (@packOutboundFlightId IS NULL AND @packReturnFlightId IS NOT NULL)
    BEGIN
        RAISERROR('You need to specify both outbound and return flights.', 16, 1);
        RETURN;
    END;

	IF (@packOutboundBusRouteId IS NOT NULL AND @packReturnBusRouteId IS NULL) OR (@packOutboundBusRouteId IS NULL AND @packReturnBusRouteId IS NOT NULL)
    BEGIN
        RAISERROR('You need to specify both outbound and return bus routes.', 16, 1);
        RETURN;
    END;

    IF @packOutboundFlightId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbl_flight WHERE fliId = @packOutboundFlightId)
    BEGIN
        RAISERROR('The specified outbound flight ID does not exist.', 16, 1);
        RETURN;
    END;

    IF @packReturnFlightId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbl_flight WHERE fliId = @packReturnFlightId)
    BEGIN
        RAISERROR('The specified return flight ID does not exist.', 16, 1);
        RETURN;
    END;

    IF @packOutboundBusRouteId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbl_busroute WHERE busRouteId = @packOutboundBusRouteId)
    BEGIN
        RAISERROR('The specified outbound bus route ID does not exist.', 16, 1);
        RETURN;
    END;

    IF @packReturnBusRouteId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbl_busroute WHERE busRouteId = @packReturnBusRouteId)
    BEGIN
        RAISERROR('The specified return bus route ID does not exist.', 16, 1);
        RETURN;
    END;

	DECLARE @packStartDate DATE;

    IF @packOutboundFlightId IS NOT NULL
        SELECT @packStartDate = fliEndTime FROM tbl_flight WHERE fliId = @packOutboundFlightId
    ELSE IF @packOutboundBusRouteId IS NOT NULL
        SELECT @packStartDate = busRouteEndTime FROM tbl_busroute WHERE busRouteId = @packOutboundBusRouteId
		
	DECLARE @packEndDate DATE;

    IF @packReturnFlightId IS NOT NULL
        SELECT @packEndDate = fliStartTime FROM tbl_flight WHERE fliId = @packReturnFlightId
    ELSE IF @packReturnBusRouteId IS NOT NULL
        SELECT @packEndDate = busRouteStartTime FROM tbl_busroute WHERE busRouteId = @packReturnBusRouteId

    IF (DATEDIFF(DAY, @packStartDate, @packEndDate) + 1) < 3 OR (DATEDIFF(DAY, @packStartDate, @packEndDate) + 1) > 30
    BEGIN
        RAISERROR('The difference in days between the start date and end date must be greater than 3 and less than 30.', 16, 1);
        RETURN;
    END;

	 IF @packMaxCapacity IS NOT NULL AND @packMaxCapacity <= 5
    BEGIN
        RAISERROR('Max capacity must be greater than 5.', 16, 1);
        RETURN;
    END;

    IF @packMinCapacity IS NOT NULL AND @packMinCapacity <= 0
    BEGIN
        RAISERROR('Min capacity must be greater than 0.', 16, 1);
        RETURN;
    END;

	IF @packMaxCapacity IS NULL
	BEGIN
		SET @packMaxCapacity = 40;
	END;

	IF @packMinCapacity IS NULL
	BEGIN
		SET @packMinCapacity = 10;
	END;
	
    DECLARE @packDuration TINYINT
    DECLARE @packPrice FLOAT

	SELECT @packDuration = DATEDIFF(DAY, @packStartDate, @packEndDate) + 1
	SELECT @packPrice = 
        (
            (SELECT hotPricePerNight FROM tbl_hotel WHERE hotId = @packHotId) * @packDuration +
            ISNULL((SELECT fliPrice FROM tbl_flight WHERE fliId = @packOutboundFlightId), 0) +
            ISNULL((SELECT fliPrice FROM tbl_flight WHERE fliId = @packReturnFlightId), 0) +
            ISNULL((SELECT busRoutePrice FROM tbl_busroute WHERE busRouteId = @packOutboundBusRouteId), 0) +
            ISNULL((SELECT busRoutePrice FROM tbl_busroute WHERE busRouteId = @packReturnBusRouteId), 0)
        ) * 1.15

    INSERT INTO tbl_package(packTitle, packDescription, packCityId, packHotId, packDuration, packPrice, packOutboundFlightId, packReturnFlightId, packOutboundBusRouteId, packReturnBusRouteId, packRepId, packMaxCapacity, packMinCapacity)
    VALUES (@packTitle, @packDescription, @packCityId, @packHotId, @packDuration, @packPrice, @packOutboundFlightId, @packReturnFlightId, @packOutboundBusRouteId, @packReturnBusRouteId, @packRepId, @packMaxCapacity, @packMinCapacity);

    PRINT 'The package has been successfully added.';
END;
GO