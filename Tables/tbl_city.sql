USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_city (
    cityId INT PRIMARY KEY IDENTITY(1,1),
    cityName VARCHAR(60),
    ctryId INT NOT NULL,
    FOREIGN KEY (ctryId) REFERENCES tbl_country(ctryId)
);
GO