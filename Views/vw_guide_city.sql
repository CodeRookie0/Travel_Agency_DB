/*--------------------------------------------------------------------------------------
View Name: vw_guide_city
--------------------------------------------------------------------------------------
Output Description:
- Id: The unique identifier of the guide.
- Name: The first name of the guide.
- Surname: The last name of the guide.
- City: The name of the city where the guide operates.
--------------------------------------------------------------------------------------
Example Invocation:

USE TRAVEL_AGENCY
GO
SELECT * FROM vw_guide_city;
--------------------------------------------------------------------------------------*/
USE TRAVEL_AGENCY
GO

CREATE OR ALTER VIEW vw_guide_city AS
SELECT g.guideId AS Id, g.guideName AS Name, g.guideSurname AS Surname, c.cityName AS City
FROM tbl_guide g
INNER JOIN tbl_city c ON g.guideCityId = c.cityId;