---------------------------------------------------------------
--- TRIGGER DEFINITION
--- trg_driver_audit
---------------------------------------------------------------
-- This trigger is designed to audit changes made to the tbl_driver table, including INSERT, UPDATE, 
-- and DELETE operations.
--
-- Trigger Events:
-- AFTER INSERT, UPDATE, DELETE
--
-- Result of the action:
-- Audits the changes made to driver records, printing the action performed (INSERT, UPDATE, DELETE) 
-- and the affected driver details.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_driver_audit
ON tbl_driver
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
        DECLARE @driverName VARCHAR(50);
        DECLARE @driverSurName VARCHAR(50);
        DECLARE @driverPhone VARCHAR(20);

        SELECT @driverName = driverName,
               @driverSurName = driverSurName,
               @driverPhone = driverPhone
        FROM inserted i;

        PRINT '';
        PRINT '--------DRIVER--------';
        PRINT 'driverName : ' + ISNULL(@driverName, '');
        PRINT 'driverSurName : ' + ISNULL(@driverSurName, '');
        PRINT 'driverPhone : ' + ISNULL(@driverPhone, '');
        PRINT '';
    END
END;
