--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_update_package
--------------------------------------------------------------------------------------------------
-- This procedure is used to update the details of a package in the database.
-- Additionally, it ensures that the specified flight or bus route matches the package city.
-- It also ensures that either flights or bus routes are specified for the package, not both.
-- If the input parameters pass all validations, the package details are updated in the database.
--
-- Input Parameters:
-- @packId: The ID of the package to be updated (required).
-- @packTitle: The updated title of the package (optional).
-- @packDescription: The updated description of the package (optional).
-- @packCityId: The updated city ID associated with the package (optional).
-- @packHotId: The updated hotel ID associated with the package (optional).
-- @packOutboundFlightId: The updated outbound flight ID associated with the package (optional).
-- @packReturnFlightId: The updated return flight ID associated with the package (optional).
-- @packOutboundBusRouteId: The updated outbound bus route ID associated with the package (optional).
-- @packReturnBusRouteId: The updated return bus route ID associated with the package (optional).
-- @packRepId: The updated representative ID associated with the package (optional).
-- @packMaxCapacity: The updated maximum capacity of the package (optional).
-- @packMinCapacity: The updated minimum capacity of the package (optional).
--
-- Output Parameters:
-- None
--
-- Example Usage:
-- EXEC up_update_package @packId = 1, @packTitle = 'Updated Package Title';
--
-- Result of the action:
-- Package data has been successfully modified.
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_update_package
    @packId INT,
    @packTitle VARCHAR(30) = NULL,
    @packDescription TEXT = NULL,
    @packCityId INT = NULL,
    @packHotId INT = NULL,
    @packOutboundFlightId INT = NULL,
    @packReturnFlightId INT = NULL,
    @packOutboundBusRouteId INT = NULL,
    @packReturnBusRouteId INT = NULL,
    @packRepId INT = NULL,
    @packMaxCapacity INT = NULL,
    @packMinCapacity INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

	IF NOT EXISTS (SELECT 1 FROM tbl_package WHERE packId = @packId)
    BEGIN
        RAISERROR('The package with the specified ID does not exist.', 16, 1);
        RETURN;
    END;

    IF @packTitle IS NOT NULL AND LEN(@packTitle) = 0
    BEGIN
        RAISERROR('The package title cannot be empty.', 16, 1);
        RETURN;
    END;

	SELECT @packCityId= COALESCE(@packCityId, packCityId) FROM tbl_package WHERE packId=@packId;

    IF @packCityId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbl_city WHERE cityId = @packCityId)
    BEGIN
        RAISERROR('The specified city ID does not exist.', 16, 1);
        RETURN;
    END;
	
	SELECT @packHotId=COALESCE(@packHotId, packHotId) FROM tbl_package WHERE packId=@packId;

    IF @packHotId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbl_hotel WHERE hotId = @packHotId)
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
	
	SELECT @packRepId=COALESCE(@packRepId, packRepId) FROM tbl_package WHERE packId=@packId;

    IF @packRepId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbl_representative WHERE repId = @packRepId)
    BEGIN
        RAISERROR('The specified representative ID does not exist.', 16, 1);
        RETURN;
    END;

    IF @packRepId IS NOT NULL AND @packCityId IS NOT NULL
    BEGIN
		SELECT @packCityId= COALESCE(@packCityId, packCityId) FROM tbl_package WHERE packId=@packId;
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
    END;

	SELECT @packOutboundFlightId = COALESCE(@packOutboundFlightId, packOutboundFlightId) FROM tbl_package WHERE packId=@packId;
    SELECT @packReturnFlightId = COALESCE(@packReturnFlightId, packReturnFlightId) FROM tbl_package WHERE packId=@packId;
    SELECT @packOutboundBusRouteId = COALESCE(@packOutboundBusRouteId, packOutboundBusRouteId) FROM tbl_package WHERE packId=@packId;
    SELECT @packReturnBusRouteId = COALESCE(@packReturnBusRouteId, packReturnBusRouteId) FROM tbl_package WHERE packId=@packId;

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
	
	IF (SELECT packOutboundFlightId FROM tbl_package WHERE packId=@packId) IS NULL AND (@packOutboundFlightId IS NOT NULL OR @packReturnFlightId IS NOT NULL)
	BEGIN
        RAISERROR('Bus routes are specified for this package. You cannot specify both flights and bus routes for the same package.', 16, 1);
        RETURN;
	END
	ELSE IF (SELECT packOutboundBusRouteId FROM tbl_package WHERE packId=@packId) IS NULL AND (@packOutboundBusRouteId IS NOT NULL OR @packReturnBusRouteId IS NOT NULL)
	BEGIN
		RAISERROR('Flights are specified for this package. You cannot specify both flights and bus routes for the same package.', 16, 1);
        RETURN;
	END;
    
	IF @packOutboundFlightId IS NOT NULL
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM tbl_flight AS F
            INNER JOIN tbl_city AS C ON F.fliEndCityId = C.cityId
            WHERE F.fliId = @packOutboundFlightId AND C.cityId <> @packCityId
        )
        BEGIN
            RAISERROR('The city of the specified outbound flight does not match the package city.', 16, 1);
            RETURN;
        END;
    END;

	IF @packReturnFlightId IS NOT NULL
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM tbl_flight AS F
            INNER JOIN tbl_city AS C ON F.fliStartCityId = C.cityId
            WHERE F.fliId = @packReturnFlightId AND C.cityId <> @packCityId
        )
        BEGIN
            RAISERROR('The city of the specified return flight does not match the package city.', 16, 1);
            RETURN;
        END;
    END;

	IF @packOutboundBusRouteId IS NOT NULL
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM tbl_busroute AS B
            INNER JOIN tbl_city AS C ON B.busRouteEndCityId = C.cityId
            WHERE B.busRouteId = @packOutboundBusRouteId AND C.cityId <> @packCityId
        )
        BEGIN
            RAISERROR('The city of the specified outbound bus route does not match the package city.', 16, 1);
            RETURN;
        END;
    END;

	IF @packReturnBusRouteId IS NOT NULL
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM tbl_busroute AS B
            INNER JOIN tbl_city AS C ON B.busRouteStartCityId = C.cityId
            WHERE B.busRouteId = @packReturnBusRouteId AND C.cityId <> @packCityId
        )
        BEGIN
            RAISERROR('The city of the specified return bus route does not match the package city.', 16, 1);
            RETURN;
        END;
    END;

    IF (@packOutboundFlightId IS NOT NULL OR @packReturnFlightId IS NOT NULL) AND (@packOutboundBusRouteId IS NOT NULL OR @packReturnBusRouteId IS NOT NULL)
    BEGIN
        RAISERROR('You cannot specify both flights and bus routes for the same package.', 16, 1);
        RETURN;
    END;

	IF (@packOutboundFlightId IS NULL AND @packReturnFlightId IS NULL) AND (@packOutboundBusRouteId IS NULL AND @packReturnBusRouteId IS NULL)
	BEGIN
		RAISERROR('You need to add either a flight or a bus route, outbound and return.', 16, 1);
		RETURN;
	END;

	DECLARE @packDuration TINYINT
    DECLARE @packPrice FLOAT
    DECLARE @packStartDate DATE
    DECLARE @packEndDate DATE

	IF @packOutboundFlightId IS NOT NULL
        SELECT @packStartDate = fliEndTime FROM tbl_flight WHERE fliId = @packOutboundFlightId
    ELSE IF @packOutboundBusRouteId IS NOT NULL
        SELECT @packStartDate = busRouteEndTime FROM tbl_busroute WHERE busRouteId = @packOutboundBusRouteId

    IF @packReturnFlightId IS NOT NULL
        SELECT @packEndDate = fliStartTime FROM tbl_flight WHERE fliId = @packReturnFlightId
    ELSE IF @packReturnBusRouteId IS NOT NULL
        SELECT @packEndDate = busRouteStartTime FROM tbl_busroute WHERE busRouteId = @packReturnBusRouteId


	SELECT @packDuration = DATEDIFF(DAY, @packStartDate, @packEndDate) + 1
	SELECT @packPrice = 
        (
            (SELECT hotPricePerNight FROM tbl_hotel WHERE hotId = @packHotId) * @packDuration +
            ISNULL((SELECT fliPrice FROM tbl_flight WHERE fliId = @packOutboundFlightId), 0) +
            ISNULL((SELECT fliPrice FROM tbl_flight WHERE fliId = @packReturnFlightId), 0) +
            ISNULL((SELECT busRoutePrice FROM tbl_busroute WHERE busRouteId = @packOutboundBusRouteId), 0) +
            ISNULL((SELECT busRoutePrice FROM tbl_busroute WHERE busRouteId = @packReturnBusRouteId), 0)
        ) * 1.15

    UPDATE tbl_package
    SET 
        packTitle = COALESCE(@packTitle, packTitle),
        packDescription = COALESCE(@packDescription, packDescription),
        packCityId = @packCityId,
        packHotId = @packHotId,
		packDuration = COALESCE(@packDuration, packDuration),
        packPrice = COALESCE(@packPrice, packPrice),
        packOutboundFlightId = @packOutboundFlightId,
        packReturnFlightId = @packReturnFlightId,
        packOutboundBusRouteId = @packOutboundBusRouteId,
        packReturnBusRouteId = @packReturnBusRouteId,
        packRepId = @packRepId,
		packMaxCapacity = COALESCE(@packMaxCapacity, packMaxCapacity),
        packMinCapacity = COALESCE(@packMinCapacity, packMinCapacity)
    WHERE packId = @packId;

	PRINT 'Package data has been successfully modified.'
END;
GO