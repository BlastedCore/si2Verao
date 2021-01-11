--Stored Procedures que inserem e removem UC de semestres de um curso
use SI2_Fase1;

--INSERT
IF OBJECT_ID ( 'dbo.sp_insertOferta', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_insertOferta;  
go

CREATE PROCEDURE dbo.sp_insertOferta
@curso varchar(6),@uc varchar(6),@semestre int

AS 

if @curso is null or @uc is null or @semestre is null 
    raiserror('Input obrigatorio de sigla de curso, sigla de UC, semestre a que pertence', 15, 1) -- with log 

SET XACT_ABORT ON
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
declare @count int
select @count =count(*) from Escola
if (@count=0) raiserror('Base não iniciada',18,1)
begin try 
begin transaction
if exists ((select 1 from dbo.Curso where sigla=@curso) intersect (select 1 from dbo.UC where sigla=@uc))insert into dbo.Oferta values(@curso,@uc,@semestre) 
else raiserror('Curso ou UC não existem',15,1)
commit transaction

end try

begin catch 

exec sp_Catch_errors 

IF (XACT_STATE()) = -1  
    BEGIN  
        PRINT  
            N'The transaction is in an uncommittable state.' +  
            'Rolling back transaction.' 
			
        ROLLBACK TRANSACTION;  
    END;  

IF (XACT_STATE()) = 1  
    BEGIN  
        PRINT  
            N'The transaction is committable.' +  
            'Committing transaction.'  
			
        COMMIT TRANSACTION;   
end
end catch;

go
--DELETE
IF OBJECT_ID ( 'dbo.sp_deleteOferta', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_deleteOferta;  
go

CREATE PROCEDURE dbo.sp_deleteOferta
@curso varchar(6),@uc varchar(6)

AS 

if @curso is null or @uc is null
    raiserror('Input obrigatorio de sigla de curso e uc', 15, 1) -- with log 

SET XACT_ABORT ON
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
declare @count int
select @count =count(*) from Escola
if (@count=0) raiserror('Base não iniciada',18,1)

begin try 
begin transaction

DELETE FROM dbo.Oferta
WHERE curso=@curso and uc=@uc

commit transaction

end try

begin catch 

exec sp_Catch_errors 

IF (XACT_STATE()) = -1  
    BEGIN  
        PRINT  
            N'The transaction is in an uncommittable state.' +  
            'Rolling back transaction.'  
        ROLLBACK TRANSACTION;  
    END;  

IF (XACT_STATE()) = 1  
    BEGIN  
        PRINT  
            N'The transaction is committable.' +  
            'Committing transaction.'  
			
        COMMIT TRANSACTION;   
end
end catch;

go
