USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_booking_archive (
    archiveId INT PRIMARY KEY IDENTITY(1,1),
	archiveAction CHAR(1) NOT NULL CHECK (archiveAction IN ('I', 'D', 'U')),
    bookId INT NOT NULL,
    bookCustId INT NOT NULL,
    bookPackageId INT NOT NULL,
    bookDiscountPercent DECIMAL(10, 2) NOT NULL,
    bookDiscountAmnt DECIMAL(10, 2) NOT NULL,
    bookPrice DECIMAL(10, 2),
	bookCreatedAt DATETIME NOT NULL,
	archivedAt DATETIME NOT NULL DEFAULT GETDATE()
);
GO