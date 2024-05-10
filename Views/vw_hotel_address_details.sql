/*--------------------------------------------------------------------------------------
View Name: vw_hotel_address_details
--------------------------------------------------------------------------------------
Output Description:
- Id: The unique identifier of the hotel.
- Name: The name of the hotel.
- Country: The name of the country where the hotel is located.
- City: The name of the city where the hotel is located.
- Region: The region of the address.
- Street: The street of the address.
- PostalCode: The postal code of the address.
- HouseNo: The house number of the address.
--------------------------------------------------------------------------------------
Example Invocation:

USE TRAVEL_AGENCY
GO
SELECT * FROM vw_hotel_address_details;
--------------------------------------------------------------------------------------*/
USE TRAVEL_AGENCY
GO

CREATE OR ALTER VIEW vw_hotel_address_details AS
SELECT h.hotId  AS Id, h.hotName  AS Name, co.ctryName  AS Country, ci.cityName  AS City, a.addrRegion AS Region, a.addrStreet AS Street, a.addrPostalCode AS PostalCode, a.addrHouseNo AS HouseNo
FROM tbl_hotel h
INNER JOIN tbl_address a ON h.hotAddrId = a.addrId
INNER JOIN tbl_city ci ON a.addrCityId = ci.cityId
INNER JOIN tbl_country co ON ci.ctryId = co.ctryId;