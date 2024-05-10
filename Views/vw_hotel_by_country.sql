/*--------------------------------------------------------------------------------------
View Name: vw_hotel_by_country
--------------------------------------------------------------------------------------
Output Description:
- CountryId: The unique identifier of the country.
- CountryName: The name of the country.
- HotelCount: The count of hotels located in the country.
--------------------------------------------------------------------------------------
Example Invocation:

USE TRAVEL_AGENCY
GO
SELECT * FROM vw_hotel_by_country;
--------------------------------------------------------------------------------------*/
USE TRAVEL_AGENCY
GO

CREATE OR ALTER VIEW vw_hotel_by_country AS
SELECT co.ctryId AS CountryId ,co.ctryName AS CountryName, COUNT(h.hotId) AS HotelCount
FROM tbl_hotel h
INNER JOIN tbl_address a ON h.hotAddrId = a.addrId
INNER JOIN tbl_city ci ON a.addrCityId = ci.cityId
INNER JOIN tbl_country co ON ci.ctryId = co.ctryId
GROUP BY co.ctryId, co.ctryName;