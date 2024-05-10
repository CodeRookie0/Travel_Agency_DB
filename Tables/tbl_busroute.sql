USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_busroute (
    busRouteId INT PRIMARY KEY IDENTITY(1,1),
    driverId INT NOT NULL,
    busRouteStartCityId INT NOT NULL,
    busRouteEndCityId INT NOT NULL,
    busRouteStartTime DATETIME NOT NULL,
    busRouteEndTime DATETIME NOT NULL,
    busRouteBusID INT NOT NULL,
	busRoutePrice DECIMAL(10, 2) NOT NULL,
    CONSTRAINT chk_busRoute_time_difference CHECK (DATEDIFF(HOUR, busRouteStartTime, busRouteEndTime) BETWEEN 1 AND 72),
    FOREIGN KEY (driverId) REFERENCES tbl_driver(driverId),
    FOREIGN KEY (busRouteStartCityId) REFERENCES tbl_city(cityId),
    FOREIGN KEY (busRouteEndCityId) REFERENCES tbl_city(cityId),
    FOREIGN KEY (busRouteBusID) REFERENCES tbl_bus(busId)
);
GO