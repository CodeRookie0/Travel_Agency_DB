USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_address_archive (
    archiveId INT PRIMARY KEY IDENTITY(1,1),
	archiveAction CHAR(1) NOT NULL CHECK (archiveAction IN ('I', 'D', 'U')),
	addrId INT NOT NULL,
    addrCityId INT NOT NULL,
    addrPostalCode VARCHAR(20),
    addrRegion VARCHAR(100),
    addrStreet VARCHAR(255) NOT NULL,
    addrHouseNo VARCHAR(10) NOT NULL,
	archivedAt DATETIME NOT NULL DEFAULT GETDATE()
);
GO
