---------------------------------------------------------------
--- TRIGGER DEFINITION
--- trg_bus_audit
---------------------------------------------------------------
-- This trigger is designed to audit changes made to the tbl_bus table, including INSERT, UPDATE, 
-- and DELETE operations.
--
-- Trigger Events:
-- AFTER INSERT, UPDATE, DELETE
--
-- Result of the action:
-- Audits the changes made to bus records, printing the action performed (INSERT, UPDATE, DELETE) 
-- and the affected bus details.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_bus_audit
ON tbl_bus
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
        DECLARE @busNo VARCHAR(20);
        DECLARE @busModel VARCHAR(50);
        DECLARE @busColor VARCHAR(20);

        SELECT @busNo = busNo,
               @busModel = busModel,
               @busColor = busColor
        FROM inserted i;

        PRINT '';
        PRINT '--------BUS--------';
        PRINT 'busNo : ' + ISNULL(@busNo, '');
        PRINT 'busModel : ' + ISNULL(@busModel, '');
        PRINT 'busColor : ' + ISNULL(@busColor, '');
        PRINT '';
    END
END;