USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_package_archive (
    archiveId INT PRIMARY KEY IDENTITY(1,1),
	archiveAction CHAR(1) NOT NULL CHECK (archiveAction IN ('I', 'D', 'U')),
	packId INT NOT NULL,
    packTitle VARCHAR(50) NOT NULL,
    packCityId INT NOT NULL,
    packHotId INT NOT NULL,
    packDuration TINYINT,
    packPrice DECIMAL(10, 2),
    packStartDate DATE,
    packEndDate DATE,
    packOutboundFlightId INT,
    packReturnFlightId INT,
    packOutboundBusRouteId INT,
    packReturnBusRouteId INT,
    packRepId INT NOT NULL,
    packMinCapacity INT NOT NULL,
    packMaxCapacity INT NOT NULL,
    packCurrentBookings INT NOT NULL,
	wasRealized BIT, 
	archivedAt DATETIME NOT NULL DEFAULT GETDATE()
);
GO