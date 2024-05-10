USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_booking (
    bookId INT PRIMARY KEY IDENTITY(1,1),
    bookCustId INT NOT NULL,
    bookPackageId INT NOT NULL,
    bookDiscountPercent DECIMAL(10, 2) NOT NULL DEFAULT 0,
    bookDiscountAmnt DECIMAL(10, 2) NOT NULL DEFAULT 0,
    bookPrice DECIMAL(10, 2),
	bookCreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (bookCustId) REFERENCES tbl_customer(custId),
    FOREIGN KEY (bookPackageId) REFERENCES tbl_package(packId)
);
GO