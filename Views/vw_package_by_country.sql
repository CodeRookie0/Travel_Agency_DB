/*--------------------------------------------------------------------------------------
View Name: vw_package_by_country
--------------------------------------------------------------------------------------
Output Description:
- CountryName: The name of the country.
- PackageCount: The count of packages available in the country.
--------------------------------------------------------------------------------------
Example Invocation:

USE TRAVEL_AGENCY
GO
SELECT * FROM vw_package_by_country;
--------------------------------------------------------------------------------------*/
USE TRAVEL_AGENCY
GO

CREATE OR ALTER VIEW vw_package_by_country AS
SELECT co.ctryName, COUNT(p.packId) AS PackageCount
FROM tbl_package p
INNER JOIN tbl_city c ON p.packCityId = c.cityId
INNER JOIN tbl_country co ON c.ctryId = co.ctryId
GROUP BY co.ctryName;