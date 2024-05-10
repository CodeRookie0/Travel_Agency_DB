---------------------------------------------------------------
--- FUNCTION DEFINITION
--- uf_return_continent_name
---------------------------------------------------------------
-- This function retrieves the name of a continent based on its identifier.
--
-- Input Parameters:
-- - @ContinentId: The identifier of the continent.
--
-- Output Parameters:
-- - @ContinentName : The name of the continent corresponding to the provided identifier.
--
-- Example Usage:
-- SELECT dbo.uf_return_continent_name(1);
--
-- Result of the action:
-- Returns the name of the continent corresponding to the provided identifier.
---------------------------------------------------------------

USE TRAVEL_AGENCY
GO

CREATE OR ALTER FUNCTION dbo.uf_return_continent_name
(
    @ContinentId INT
)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @ContinentName VARCHAR(100);

    SELECT @ContinentName = contName
    FROM tbl_continent
    WHERE contId = @ContinentId;

    RETURN @ContinentName;
END;