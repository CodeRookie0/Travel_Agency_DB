---------------------------------------------------------------
--- TRIGGER DEFINITION
--- trg_flight_audit
---------------------------------------------------------------
-- This trigger is designed to audit changes made to the tbl_flight table, including INSERT, UPDATE, 
-- and DELETE operations.
--
-- Trigger Events:
-- AFTER INSERT, UPDATE, DELETE
--
-- Result of the action:
-- Audits the changes made to flight records, printing the action performed (INSERT, UPDATE, DELETE) 
-- and the affected flight details.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_flight_audit
ON tbl_flight
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Action NVARCHAR(10);

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        SET @Action = 'UPDATE';
    END
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN
        SET @Action = 'INSERT';
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        SET @Action = 'DELETE';
    END

    PRINT 'Action: ' + @Action;

    IF @Action IN ('INSERT', 'UPDATE')
    BEGIN
        DECLARE @fliStartCityId INT;
        DECLARE @fliEndCityId INT;
        DECLARE @fliStartTime DATETIME;
        DECLARE @fliEndTime DATETIME;
        DECLARE @fliClass VARCHAR(10);
        DECLARE @fliPrice DECIMAL(10, 2);

        SELECT @fliStartCityId = fliStartCityId,
               @fliEndCityId = fliEndCityId,
               @fliStartTime = fliStartTime,
               @fliEndTime = fliEndTime,
               @fliClass = fliClass,
               @fliPrice = fliPrice
        FROM inserted i;

        PRINT '';
        PRINT '--------FLIGHT--------';
        PRINT 'fliStartCityId : ' + ISNULL(CONVERT(VARCHAR(10), @fliStartCityId), '');
        PRINT 'fliEndCityId : ' + ISNULL(CONVERT(VARCHAR(10), @fliEndCityId), '');
        PRINT 'fliStartTime : ' + ISNULL(CONVERT(VARCHAR(30), @fliStartTime, 120), '');
        PRINT 'fliEndTime : ' + ISNULL(CONVERT(VARCHAR(30), @fliEndTime, 120), '');
        PRINT 'fliClass : ' + ISNULL(@fliClass, '');
        PRINT 'fliPrice : ' + ISNULL(CONVERT(VARCHAR(20), @fliPrice), '');
        PRINT '';
    END
END;