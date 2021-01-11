use SI2_Fase1;

IF OBJECT_ID ( 'dbo.sp_GetSpecifics', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_GetSpecifics;  
GO  

CREATE PROCEDURE dbo.sp_GetSpecifics

AS 
DECLARE @name NVARCHAR(100)
DECLARE @getname CURSOR

SET @getname = CURSOR FOR
SELECT name  FROM dbo.sysobjects  WHERE (type = 'P')

OPEN @getname
FETCH NEXT
FROM @getname INTO @name
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC sp_GetParams @sp=@name
    FETCH NEXT
    FROM @getname INTO @name
END

CLOSE @getname
DEALLOCATE @getname
Return 
GO