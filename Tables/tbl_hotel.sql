USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_hotel (
    hotId INT PRIMARY KEY IDENTITY(1,1),
    hotAddrId INT NOT NULL,
    hotName VARCHAR(50) NOT NULL,
    hotPricePerNight DECIMAL(10, 2) NOT NULL,
    hotTelephoneNo VARCHAR(20),
    hotContactEmail VARCHAR(45),
	hotStars INT CHECK (hotStars IS NULL OR (hotStars >= 0 AND hotStars <= 5)),
    FOREIGN KEY (hotAddrId) REFERENCES tbl_address(addrId)
);
GO