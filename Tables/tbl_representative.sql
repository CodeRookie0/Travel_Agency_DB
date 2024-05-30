USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_representative (
    repId INT PRIMARY KEY IDENTITY(1,1),
    repName VARCHAR(50) NOT NULL,
    repSurname VARCHAR(50) NOT NULL,
    repCityId INT NOT NULL,
    repPhone VARCHAR(20) NOT NULL,
    FOREIGN KEY (repCityId) REFERENCES tbl_city(cityId)
);
GO