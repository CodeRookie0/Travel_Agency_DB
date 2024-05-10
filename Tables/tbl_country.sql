USE TRAVEL_AGENCY
GO

CREATE TABLE tbl_country (
    ctryId INT PRIMARY KEY IDENTITY(1,1),
    ctryName VARCHAR(45) UNIQUE,
    contId INT NOT NULL,
    FOREIGN KEY (contId) REFERENCES tbl_continent(contId)
);
GO