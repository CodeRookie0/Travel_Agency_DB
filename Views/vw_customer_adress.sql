/*--------------------------------------------------------------------------------------
View Name: vw_customer_address
--------------------------------------------------------------------------------------
Output Description:
- Id: The unique identifier of the customer.
- Name: The first name of the customer.
- Surname: The last name of the customer.
- City: The name of the city where the customer resides.
- Region: The region of the address.
- Street: The street of the address.
- PostalCode: The postal code of the address.
- HouseNo: The house number of the address.
--------------------------------------------------------------------------------------
Example Invocation:

USE TRAVEL_AGENCY
GO
SELECT * FROM vw_customer_address;
--------------------------------------------------------------------------------------*/
USE TRAVEL_AGENCY
GO

CREATE OR ALTER VIEW vw_customer_address AS
SELECT cu.custId AS Id, cu.custName AS Name, cu.custSurname AS Surname, c.cityName AS City, 
	a.addrRegion AS Region, a.addrStreet AS Street, a.addrPostalCode AS PostalCode, a.addrHouseNo AS HouseNo
FROM tbl_customer cu
INNER JOIN tbl_address a ON cu.custAddrId = a.addrId
INNER JOIN tbl_city c ON a.addrCityId = c.cityId;