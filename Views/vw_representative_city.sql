/*--------------------------------------------------------------------------------------
View Name: vw_representative_city
--------------------------------------------------------------------------------------
Output Description:
- Id: The unique identifier of the representative.
- Name: The first name of the representative.
- Surname: The last name of the representative.
- City: The name of the city where the representative operates.
--------------------------------------------------------------------------------------
Example Invocation:

USE TRAVEL_AGENCY
GO
SELECT * FROM vw_representative_city;
--------------------------------------------------------------------------------------*/
USE TRAVEL_AGENCY
GO

CREATE OR ALTER VIEW vw_representative_city AS
SELECT r.repId AS Id, r.repName AS Name, r.repSurname AS Surname, c.cityName AS City
FROM tbl_representative r
INNER JOIN tbl_city c ON r.repCityId = c.cityId;