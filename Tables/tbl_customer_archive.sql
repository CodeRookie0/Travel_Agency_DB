USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_customer_archive (
    archiveId INT PRIMARY KEY IDENTITY(1,1),
	archiveAction CHAR(1) NOT NULL CHECK (archiveAction IN ('I', 'D', 'U')),
	custId INT NOT NULL,
    custName VARCHAR(50) NOT NULL,
    custSurname VARCHAR(50) NOT NULL,
    custPhone VARCHAR(20) NOT NULL,
    custEmailAddress VARCHAR(255),
    custAddrId INT NOT NULL,
	archivedAt DATETIME NOT NULL DEFAULT GETDATE()
);
GO