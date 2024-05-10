---------------------------------------------------------------
--- TRIGGER DEFINITION
--- trg_guide_audit
---------------------------------------------------------------
-- This trigger is designed to audit changes made to the tbl_guide table, including INSERT, UPDATE, 
-- and DELETE operations.
--
-- Trigger Events:
-- AFTER INSERT, UPDATE, DELETE
--
-- Result of the action:
-- Audits the changes made to guide records, printing the action performed (INSERT, UPDATE, DELETE) 
-- and the affected guide details.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER TRIGGER trg_guide_audit
ON tbl_guide
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
        DECLARE @guideName VARCHAR(50);
        DECLARE @guideSurname VARCHAR(50);
        DECLARE @guideCityId INT;
        DECLARE @guidePhone VARCHAR(20);

        SELECT @guideName = guideName,
               @guideSurname = guideSurname,
               @guideCityId = guideCityId,
               @guidePhone = guidePhone
        FROM inserted i;

        PRINT '';
        PRINT '--------GUIDE--------';
        PRINT 'guideName : ' + ISNULL(@guideName, '');
        PRINT 'guideSurname : ' + ISNULL(@guideSurname, '');
        PRINT 'guideCityId : ' + ISNULL(CONVERT(VARCHAR(10), @guideCityId), '');
        PRINT 'guidePhone : ' + ISNULL(@guidePhone, '');
        PRINT '';
    END
END;