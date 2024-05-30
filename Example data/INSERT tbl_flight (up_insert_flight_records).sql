--------------------------------------------------------------------------------------------------
--- PROCEDURE DEFINITION
--- up_insert_flight_records
--------------------------------------------------------------------------------------------------
-- This procedure is used to generate flight records between all possible city combinations.
-- It inserts flight records into the tbl_flight table with random flight start and end times,
-- and prices for different classes (Economy, Business, First).
--
--
-- Example Usage:
-- EXEC up_insert_flight_records
--
-- Result of the action
-- Procedure adds flights
--------------------------------------------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER PROCEDURE up_insert_flight_records
AS
BEGIN
    DECLARE @StartCityId INT
    DECLARE @EndCityId INT
    DECLARE @EconomyPrice FLOAT
    DECLARE @BusinessPrice FLOAT
    DECLARE @FirstClassPrice FLOAT
	DECLARE @RandomHours INT
	DECLARE @RandomDiff INT
    DECLARE @StartTime DATETIME
    DECLARE @EndTime DATETIME

    CREATE TABLE #tbl_city_combinations (
        StartCityId INT,
        EndCityId INT
    )

    INSERT INTO #tbl_city_combinations (StartCityId, EndCityId)
    SELECT c1.cityId AS StartCityId, c2.cityId AS EndCityId
    FROM tbl_city c1
    CROSS JOIN tbl_city c2
    WHERE c1.cityId <> c2.cityId

    DECLARE crs_city_list CURSOR FOR 
        SELECT StartCityId, EndCityId FROM #tbl_city_combinations

    OPEN crs_city_list  
    FETCH NEXT FROM crs_city_list INTO @StartCityId, @EndCityId  

    WHILE @@FETCH_STATUS = 0  
    BEGIN  
        SET @EconomyPrice = ROUND(RAND() * (300 - 70) + 70, 2)
        SET @BusinessPrice = ROUND(@EconomyPrice + 100, 2)
        SET @FirstClassPrice =ROUND(@EconomyPrice + 250, 2) 

        SET @RandomHours = ROUND(RAND() * (4760 - 168) + 168, 0)
		SET @StartTime = DATEADD(HOUR, @RandomHours, GETDATE())

		SET @RandomDiff = ROUND(RAND() * (19 - 1) + 1, 0)
		SET @EndTime = DATEADD(HOUR, @RandomDiff, @StartTime)

        INSERT INTO tbl_flight(fliStartCityId, fliEndCityId, fliStartTime, fliEndTime, fliClass, fliPrice)
        VALUES (@StartCityId, @EndCityId, @StartTime, @EndTime, 'Economy', @EconomyPrice),
               (@StartCityId, @EndCityId, @StartTime, @EndTime, 'Business', @BusinessPrice),
               (@StartCityId, @EndCityId, @StartTime, @EndTime, 'First', @FirstClassPrice)

        FETCH NEXT FROM crs_city_list INTO @StartCityId, @EndCityId
    END  

    CLOSE crs_city_list  
    DEALLOCATE crs_city_list

    DROP TABLE #tbl_city_combinations
END

/* -------------------------------------------------------------------------------------------------------*/

DECLARE @Counter INT = 0

WHILE @Counter < 5
BEGIN
    EXEC up_insert_flight_records
    SET @Counter = @Counter + 1
END

/* -------------------------------------------------------------------------------------------------------*/
USE TRAVEL_AGENCY
GO
select count(*) from tbl_flight