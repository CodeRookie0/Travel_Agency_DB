/*--------------------------------------------------------------------------------------
View Name: vw_hotel_by_city
--------------------------------------------------------------------------------------
Output Description:
- CityId: The unique identifier of the city.
- CityName: The name of the city.
- HotelCount: The count of hotels located in the city.
--------------------------------------------------------------------------------------
Example Invocation:

USE TRAVEL_AGENCY
GO
SELECT * FROM vw_hotel_by_city;
--------------------------------------------------------------------------------------*/
USE TRAVEL_AGENCY
GO

CREATE OR ALTER VIEW vw_hotel_by_city AS
SELECT ci.cityId AS CityId, ci.cityName AS CityName, COUNT(h.hotId) AS HotelCount
FROM tbl_hotel h
INNER JOIN tbl_address a ON h.hotAddrId = a.addrId
INNER JOIN tbl_city ci ON a.addrCityId = ci.cityId
GROUP BY ci.cityId, ci.cityName;