/*--------------------------------------------------------------------------------------
View Name: vw_busdriver_details
--------------------------------------------------------------------------------------
Output Description:
- Id: The unique identifier of the bus driver.
- Name: The name of the bus driver.
- Surname: The surname of the bus driver.
- Phone: The phone number of the bus driver.
--------------------------------------------------------------------------------------
Example Invocation:

USE TRAVEL_AGENCY
GO
SELECT * FROM vw_busdriver_details;
--------------------------------------------------------------------------------------*/
Use TRAVEL_AGENCY
GO

CREATE OR ALTER VIEW vw_busdriver_details AS
SELECT d.driverId AS Id, d.driverName AS Name, d.driverSurName AS Surname, d.driverPhone AS Phone
FROM tbl_driver d;