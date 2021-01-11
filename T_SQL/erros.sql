use SI2_Fase1;

IF OBJECT_ID ( 'dbo.sp_Catch_errors', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_Catch_errors;  
GO  

CREATE PROCEDURE dbo.sp_Catch_errors  
AS  
select
    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage; 
GO