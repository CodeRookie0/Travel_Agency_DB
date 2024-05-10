/*--------------------------------------------------------------------------------------
View Name: vw_customers_by_country
--------------------------------------------------------------------------------------
Output Description:
- CustomerCount: The count of customers residing in each country.
- Country: The name of the country.
--------------------------------------------------------------------------------------
Example Invocation:

USE TRAVEL_AGENCY
GO
SELECT * FROM vw_customers_by_country;
-------------------------------------------------------------------------------------*/
USE TRAVEL_AGENCY
GO

CREATE OR ALTER VIEW vw_customers_by_country AS
SELECT COUNT(cu.custId) AS CustomerCount, co.ctryName AS Country
FROM tbl_customer cu
INNER JOIN tbl_address a ON cu.custAddrId = a.addrId
INNER JOIN tbl_city c ON a.addrCityId = c.cityId
INNER JOIN tbl_country co ON c.ctryId = co.ctryId
GROUP BY co.ctryName;