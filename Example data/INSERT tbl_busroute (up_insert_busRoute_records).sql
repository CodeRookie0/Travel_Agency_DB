--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_insert_busRoute_records
--------------------------------------------------------------------------------------------------
-- This procedure is used to generate bus route records between all possible city combinations.
-- It inserts bus route records into the tbl_busroute table with random start and end times,
-- drivers, buses, and prices.
--
--
-- Example Usage:
-- EXEC up_insert_busRoute_records
--
-- Result of the action
-- Procedure adds bus routes
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_insert_busRoute_records
AS
BEGIN
    DECLARE @StartCityId INT;
    DECLARE @EndCityId INT;
    DECLARE @DriverId INT;
    DECLARE @BusId INT;
    DECLARE @StartTime DATETIME;
    DECLARE @EndTime DATETIME;
    DECLARE @HoursToAdd INT;
    DECLARE @Price FLOAT;

    CREATE TABLE #tbl_city_combinations (
        StartCityId INT,
        EndCityId INT
    );

    INSERT INTO #tbl_city_combinations (StartCityId, EndCityId)
    SELECT c1.cityId AS StartCityId, c2.cityId AS EndCityId
    FROM tbl_city c1
    CROSS JOIN tbl_city c2
    WHERE c1.cityId <> c2.cityId;

    DECLARE crs_city_list CURSOR FOR 
        SELECT StartCityId, EndCityId FROM #tbl_city_combinations;

    OPEN crs_city_list;  
    FETCH NEXT FROM crs_city_list INTO @StartCityId, @EndCityId;  

    WHILE @@FETCH_STATUS = 0  
    BEGIN  
        SET @DriverId = ROUND(RAND() * ((SELECT ISNULL(MAX(driverId), 0) + 1 FROM tbl_driver) - 1) + 1, 0);
        SET @BusId = ROUND(RAND() * ((SELECT ISNULL(MAX(busId), 0) + 1 FROM tbl_bus) - 1) + 1, 0);
        SET @StartTime = DATEADD(HOUR, ROUND(RAND() * (4760 - 168) + 168, 0), GETDATE());
        SET @HoursToAdd = ROUND(RAND() * (72 - 1) + 1, 0);
        SET @EndTime = DATEADD(HOUR, @HoursToAdd, @StartTime);
        SET @Price = ROUND(RAND() * (250 - 50) + 50, 2);

        INSERT INTO tbl_busroute (driverId, busRouteStartCityId, busRouteEndCityId, busRouteStartTime, busRouteEndTime, busRouteBusID, busRoutePrice)
        VALUES (@DriverId, @StartCityId, @EndCityId, @StartTime, @EndTime, @BusId, @Price);

        FETCH NEXT FROM crs_city_list INTO @StartCityId, @EndCityId;
    END  

    CLOSE crs_city_list;  
    DEALLOCATE crs_city_list;

    DROP TABLE #tbl_city_combinations;
END;

/* -------------------------------------------------------------------------------------------------------*/

DECLARE @Counter INT = 0

WHILE @Counter < 5
BEGIN
    EXEC up_insert_busRoute_records
    SET @Counter = @Counter + 1
END

/* -------------------------------------------------------------------------------------------------------*/
USE TRAVEL_AGENCY
GO
select count(*) from tbl_busroute 