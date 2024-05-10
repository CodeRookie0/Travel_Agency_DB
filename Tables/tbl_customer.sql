USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_customer (
    custId INT PRIMARY KEY IDENTITY(1,1),
    custName VARCHAR(50) NOT NULL,
    custSurname VARCHAR(50) NOT NULL,
    custPhone VARCHAR(20) NOT NULL,
    custEmailAddress VARCHAR(255),
    custAddrId INT NOT NULL,
    FOREIGN KEY (custAddrId) REFERENCES tbl_address(addrId)
);
GO