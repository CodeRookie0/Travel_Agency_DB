/*--------------------------------------------------------------------------------------
View Name: vw_flight_details
--------------------------------------------------------------------------------------
Output Description:
- Id: The unique identifier of the flight.
- StartCity: The name of the city where the flight starts.
- EndCity: The name of the city where the flight ends.
- DepartureDate: The date of departure.
- DepartureTime: The time of departure.
- ArrivalDate: The date of arrival.
- ArrivalTime: The time of arrival.
- Class: The class of the flight.
- Price: The price of the flight.
--------------------------------------------------------------------------------------
Example Invocation:

USE TRAVEL_AGENCY
GO
SELECT * FROM vw_flight_details;
--------------------------------------------------------------------------------------*/
USE TRAVEL_AGENCY
GO

CREATE OR ALTER VIEW vw_flight_details AS
SELECT f.fliId AS Id, s.cityName AS StartCity, e.cityName AS EndCity, CONVERT(DATE, f.fliStartTime) AS DepartureDate,FORMAT(f.fliStartTime, 'HH:mm') AS DepartureTime, CONVERT(DATE, f.fliEndTime) AS ArrivalDate,FORMAT(f.fliEndTime, 'HH:mm') AS ArrivalTime, f.fliClass AS Class, f.fliPrice AS Price
FROM tbl_flight f
INNER JOIN tbl_city s ON f.fliStartCityId = s.cityId
INNER JOIN tbl_city e ON f.fliEndCityId = e.cityId;