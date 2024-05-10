USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_package (
    packId INT PRIMARY KEY IDENTITY(1,1),
    packTitle VARCHAR(50) NOT NULL,
    packDescription TEXT,
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
    packGuideId INT NOT NULL,
    CONSTRAINT chk_flight_or_busRoute 
        CHECK (
            (packOutboundFlightId IS NOT NULL AND packReturnFlightId IS NOT NULL) OR 
            (packOutboundBusRouteId IS NOT NULL AND packReturnBusRouteId IS NOT NULL)
        ),
	CONSTRAINT chk_packDuration_range 
        CHECK (packDuration BETWEEN 3 AND 30),
    FOREIGN KEY (packCityId) REFERENCES tbl_city(cityId),
    FOREIGN KEY (packHotId) REFERENCES tbl_hotel(hotId),
    FOREIGN KEY (packOutboundFlightId) REFERENCES tbl_flight(fliId),
    FOREIGN KEY (packReturnFlightId) REFERENCES tbl_flight(fliId),
    FOREIGN KEY (packOutboundBusRouteId) REFERENCES tbl_busroute(busRouteId),
    FOREIGN KEY (packReturnBusRouteId) REFERENCES tbl_busroute(busRouteId),
    FOREIGN KEY (packGuideId) REFERENCES tbl_guide(guideId)
);
GO