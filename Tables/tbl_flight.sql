USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_flight (
    fliId INT PRIMARY KEY IDENTITY(1,1),
    fliStartCityId INT NOT NULL,
    fliEndCityId INT NOT NULL,
    fliStartTime DATETIME NOT NULL,
    fliEndTime DATETIME NOT NULL,
    fliClass VARCHAR(10) NOT NULL CHECK (fliClass IN ('First', 'Business', 'Economy')),
    fliPrice DECIMAL(10, 2) NOT NULL,
	CONSTRAINT chk_flight_time_difference CHECK (DATEDIFF(HOUR, fliStartTime, fliEndTime) BETWEEN 1 AND 19),
    FOREIGN KEY (fliStartCityId) REFERENCES tbl_city(cityId),
    FOREIGN KEY (fliEndCityId) REFERENCES tbl_city(cityId)
);
GO