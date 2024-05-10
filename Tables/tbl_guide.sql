USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_guide (
    guideId INT PRIMARY KEY IDENTITY(1,1),
    guideName VARCHAR(50) NOT NULL,
    guideSurname VARCHAR(50) NOT NULL,
    guideCityId INT NOT NULL,
    guidePhone VARCHAR(20) NOT NULL,
    FOREIGN KEY (guideCityId) REFERENCES tbl_city(cityId)
);
GO