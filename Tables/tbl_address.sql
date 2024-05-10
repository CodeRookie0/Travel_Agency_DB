USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_address (
    addrId INT PRIMARY KEY IDENTITY(1,1),
    addrCityId INT NOT NULL,
    addrPostalCode VARCHAR(20),
    addrRegion VARCHAR(100),
    addrStreet VARCHAR(255) NOT NULL,
    addrHouseNo VARCHAR(10) NOT NULL,
    FOREIGN KEY (addrCityId) REFERENCES tbl_city(cityId)
);
GO