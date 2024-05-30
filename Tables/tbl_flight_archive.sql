USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_flight_archive (
    archiveId INT PRIMARY KEY IDENTITY(1,1),
	archiveAction CHAR(1) NOT NULL CHECK (archiveAction IN ('I', 'D', 'U')),
	fliId INT NOT NULL,
    fliStartCityId INT NOT NULL,
    fliEndCityId INT NOT NULL,
    fliStartTime DATETIME NOT NULL,
    fliEndTime DATETIME NOT NULL,
    fliClass VARCHAR(10) NOT NULL,
    fliPrice DECIMAL(10, 2) NOT NULL,
	archivedAt DATETIME NOT NULL DEFAULT GETDATE()
);
GO