/*--------------------------------------------------------------------------------------
View Name: vw_booking_details
--------------------------------------------------------------------------------------
Output Description:
- Id: The unique identifier of the booking.
- CustomerName: The name of the customer who made the booking.
- CustomerSurname: The surname of the customer who made the booking.
- Title: The title of the package booked.
- Discount: The discount percentage applied to the booking.
- DiscountAmount: The amount of discount applied to the booking.
- TotalPrice: The total price of the booking after discount.
--------------------------------------------------------------------------------------
Example Invocation:

USE TRAVEL_AGENCY
GO
SELECT * FROM vw_booking_details;
--------------------------------------------------------------------------------------*/
USE TRAVEL_AGENCY
GO

CREATE OR ALTER VIEW vw_booking_details AS
SELECT b.bookId AS Id, c.custName AS CustomerName, c.custSurname AS CustomerSurame, p.packTitle AS Title, b.bookDiscountPercent AS Discount, b.bookDiscountAmnt AS DiscountAmount, b.bookPrice AS TotalPrice
FROM tbl_booking b
INNER JOIN tbl_customer c ON b.bookCustId = c.custId
INNER JOIN tbl_package p ON b.bookPackageId = p.packId;