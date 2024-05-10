/*--------------------------------------------------------------------------------------
View Name: vw_hotel_contact_details
--------------------------------------------------------------------------------------
Output Description:
- Id: The unique identifier of the hotel.
- Name: The name of the hotel.
- TelephoneNo: The telephone number of the hotel.
- Email: The contact email of the hotel.
--------------------------------------------------------------------------------------
Example Invocation:

USE TRAVEL_AGENCY
GO
SELECT * FROM vw_hotel_contact_details;
--------------------------------------------------------------------------------------*/
USE TRAVEL_AGENCY
GO

CREATE OR ALTER VIEW vw_hotel_contact_details AS
SELECT h.hotId  AS Id, h.hotName  AS Name, h.hotTelephoneNo  AS TelephoneNo, h.hotContactEmail  AS Email
FROM tbl_hotel h
INNER JOIN tbl_address a ON h.hotAddrId = a.addrId
INNER JOIN tbl_city ci ON a.addrCityId = ci.cityId
INNER JOIN tbl_country co ON ci.ctryId = co.ctryId;