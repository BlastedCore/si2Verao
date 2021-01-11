--Stored Procedures referentes a dbo.Seccao
use SI2_Fase1;

--Insert
IF OBJECT_ID ( 'dbo.sp_insertSeccao', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_insertSeccao;  
go

CREATE PROCEDURE dbo.sp_insertSeccao
@sigla varchar(6),@departamento varchar(6),@descricao varchar(256)

AS 

if @sigla is null or @departamento is null
    raiserror('Input obrigatorio de sigla e departamento', 15, 1) -- with log 

SET XACT_ABORT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
declare @count int
select @count =count(*) from Escola
if (@count=0) raiserror('Base não iniciada',18,1)
begin try 
begin transaction

Insert into  dbo.Seccao
Values (@sigla,@descricao,@departamento)

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

--Delete
IF OBJECT_ID ( 'dbo.sp_deleteSeccao', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_deleteSeccao;  
go

CREATE PROCEDURE dbo.sp_deleteSeccao
@sigla varchar(6)

AS 

if @sigla is null 
    raiserror('Input obrigatorio de sigla', 15, 1) -- with log 

SET XACT_ABORT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
declare @count int
select @count =count(*) from Escola
if (@count=0) raiserror('Base não iniciada',18,1)
begin try 
begin transaction

DELETE FROM dbo.Seccao
WHERE sigla = @sigla

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

--Update
IF OBJECT_ID ( 'dbo.sp_updateSeccao', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_updateSeccao;  
go

CREATE PROCEDURE dbo.sp_updateSeccao
@id int,@sigla varchar(6),@descricao varchar(256),@departamento varchar(6)

AS 

if @id is null or @sigla is null or @departamento is null
    raiserror('Input obrigatorio de id, sigla e departamento', 15, 1) -- with log 

SET XACT_ABORT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
declare @count int
select @count =count(*) from Escola
if (@count=0) raiserror('Base não iniciada',18,1)
begin try 
begin transaction

update dbo.Seccao
set sigla=@sigla,descricao=@descricao,departamento=@departamento where  id=@id

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
