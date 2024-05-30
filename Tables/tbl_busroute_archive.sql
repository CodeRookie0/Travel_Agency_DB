USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_busroute_archive (
    archiveId INT PRIMARY KEY IDENTITY(1,1),
	archiveAction CHAR(1) NOT NULL CHECK (archiveAction IN ('I', 'D', 'U')),
	busRouteId INT NOT NULL,
    driverId INT NOT NULL,
    busRouteStartCityId INT NOT NULL,
    busRouteEndCityId INT NOT NULL,
    busRouteStartTime DATETIME NOT NULL,
    busRouteEndTime DATETIME NOT NULL,
    busRouteBusID INT NOT NULL,
	busRoutePrice DECIMAL(10, 2) NOT NULL,
	archivedAt DATETIME NOT NULL DEFAULT GETDATE()
);
GO