--Stored Procedures referentes a dbo.Departamento
use SI2_Fase1;

--Insert
IF OBJECT_ID ( 'dbo.sp_insertDepartamento', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_insertDepartamento;  
go

CREATE PROCEDURE dbo.sp_insertDepartamento
@sigla varchar(6),@descricao varchar(256)


AS 

if @sigla is null
    raiserror('Input obrigatorio de sigla de departamento', 15, 1) -- with log 

SET XACT_ABORT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
declare @count int
select @count =count(*) from Escola
if (@count=0) raiserror('Base não iniciada',18,1)
begin try 
begin transaction
declare @escola varchar(6)
select @escola=nome from Escola 
Insert into  dbo.Departamento
Values (@escola,@sigla,@descricao)

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
IF OBJECT_ID ( 'dbo.sp_deleteDepartamento', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_deleteDepartamento;  
go

CREATE PROCEDURE dbo.sp_deleteDepartamento
@sigla varchar(6)

AS 

if @sigla is null 
    raiserror('Input obrigatorio de sigla de departamento', 15, 1) -- with log 

SET XACT_ABORT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

declare @count int
select @count =count(*) from Escola
if (@count=0) raiserror('Base não iniciada',18,1)
begin try 
begin transaction

DELETE FROM [dbo].[Departamento]
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
IF OBJECT_ID ( 'dbo.sp_updateDepartamento', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_updateDepartamento;  
go

CREATE PROCEDURE dbo.sp_updateDepartamento
@id int,@sigla varchar(6),@descricao varchar(256)

AS 

if @id is null or @sigla is null 
    raiserror('Input obrigatorio de id e sigla', 15, 1) -- with log 

SET XACT_ABORT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
declare @count int
select @count =count(*) from Escola
if (@count=0) raiserror('Base não iniciada',18,1)
begin try 
begin transaction

update dbo.Departamento
set sigla=@sigla,descricao=@descricao where id=@id

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
