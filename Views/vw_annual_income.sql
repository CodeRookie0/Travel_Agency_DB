/*--------------------------------------------------------------------------------------
View Name: vw_annual_income
--------------------------------------------------------------------------------------
Output Description:
- BookingYear: The year of the booking.
- BookingMonth: The month of the booking.
- TotalPrice: The total price of bookings made in the specified year and month.
- TotalDiscountAmount: The total amount of discount applied to bookings made in the specified year and month.
- Income: The income generated from bookings after applying taxes.
--------------------------------------------------------------------------------------
Example Invocation:

USE TRAVEL_AGENCY
GO
SELECT * FROM vw_annual_income;
--------------------------------------------------------------------------------------*/
USE TRAVEL_AGENCY
GO

CREATE OR ALTER VIEW vw_annual_income AS
SELECT YEAR(b.bookCreatedAt) AS BookingYear,MONTH(b.bookCreatedAt) AS BookingMonth, 
SUM(b.bookPrice) AS TotalPrice, SUM(b.bookDiscountAmnt) AS TotalDiscountAmount,
CAST(SUM((((b.bookPrice + b.bookDiscountAmnt) / 115) * 15) - b.bookDiscountAmnt) AS DECIMAL(10, 2)) AS Income
FROM tbl_booking b
GROUP BY YEAR(b.bookCreatedAt),MONTH(b.bookCreatedAt);