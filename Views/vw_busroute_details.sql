/*--------------------------------------------------------------------------------------
View Name: vw_busroute_details
--------------------------------------------------------------------------------------
Output Description:
- Id: The unique identifier of the bus route.
- DriverName: The name of the driver.
- DriverSurname: The surname of the driver.
- DriverPhone: The phone number of the driver.
- BusNo: The number of the bus.
- BusModel: The model of the bus.
- BusColor: The color of the bus.
- DepartureDate: The date of departure.
- DepartureTime: The time of departure.
- ArrivalDate: The date of arrival.
- ArrivalTime: The time of arrival.
- StartCity: The name of the city where the bus route starts.
- EndCity: The name of the city where the bus route ends.
--------------------------------------------------------------------------------------
Example Invocation:

USE TRAVEL_AGENCY
GO
SELECT * FROM vw_busroute_details;
--------------------------------------------------------------------------------------*/
USE TRAVEL_AGENCY
GO

CREATE OR ALTER VIEW vw_busroute_details AS
SELECT br.busRouteId AS Id,  d.driverName AS DriverName, d.driverSurName AS DriverSurname, d.driverPhone AS DriverPhone, b.busNo AS BusNo, b.busModel AS BusModel, b.busColor AS BusColor,CONVERT(DATE, br.busRouteStartTime) AS DepartureDate,FORMAT(br.busRouteStartTime, 'HH:mm') AS DepartureTime, CONVERT(DATE, br.busRouteEndTime) AS ArrivalDate, FORMAT(br.busRouteEndTime, 'HH:mm') AS ArrivalTime, s.cityName AS StartCity, e.cityName AS EndCity
FROM tbl_busroute br
INNER JOIN tbl_driver d ON br.driverId = d.driverId
INNER JOIN tbl_bus b ON br.busRouteBusID = b.busId
INNER JOIN tbl_city s ON br.busRouteStartCityId = s.cityId
INNER JOIN tbl_city e ON br.busRouteEndCityId = e.cityId;