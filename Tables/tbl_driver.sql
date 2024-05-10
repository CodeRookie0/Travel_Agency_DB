USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_driver (
    driverId INT PRIMARY KEY IDENTITY(1,1),
    driverName VARCHAR(50) NOT NULL,
    driverSurName VARCHAR(50) NOT NULL,
    driverPhone VARCHAR(20) NOT NULL
);
GO