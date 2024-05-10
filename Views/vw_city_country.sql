/*--------------------------------------------------------------------------------------
View Name: vw_city_country
--------------------------------------------------------------------------------------
Output Description:
- Id: The unique identifier of the city.
- City: The name of the city.
- Country: The name of the country to which the city belongs.
--------------------------------------------------------------------------------------
Example Invocation:

USE TRAVEL_AGENCY
GO
SELECT * FROM vw_city_country;
--------------------------------------------------------------------------------------*/
USE TRAVEL_AGENCY
GO

CREATE OR ALTER VIEW vw_city_country AS
SELECT c.cityId AS Id, c.cityName AS City, co.ctryName AS Country
FROM tbl_city c
INNER JOIN tbl_country co ON c.ctryId = co.ctryId;