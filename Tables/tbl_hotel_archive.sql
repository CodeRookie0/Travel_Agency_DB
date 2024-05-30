USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_hotel_archive (
    archiveId INT PRIMARY KEY IDENTITY(1,1),
	archiveAction CHAR(1) NOT NULL CHECK (archiveAction IN ('I', 'D', 'U')),
	hotId INT NOT NULL,
    hotAddrId INT NOT NULL,
    hotName VARCHAR(50) NOT NULL,
    hotPricePerNight DECIMAL(10, 2) NOT NULL,
    hotTelephoneNo VARCHAR(20),
    hotContactEmail VARCHAR(45),
	hotStars INT,
	archivedAt DATETIME NOT NULL DEFAULT GETDATE()
);
GO