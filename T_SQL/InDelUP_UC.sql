--Stored Procedures referentes a dbo.UC
use SI2_Fase1;

--Insert
IF OBJECT_ID ( 'dbo.sp_insertUC', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_insertUC;  
go

CREATE PROCEDURE dbo.sp_insertUC
@sigla varchar(6),@descricao varchar(256),@creditos float

AS 

if @sigla is null or @creditos is null
    raiserror('Input obrigatorio de sigla e creditos', 15, 1) -- with log 

SET XACT_ABORT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
declare @count int
select @count =count(*) from Escola
if (@count=0) raiserror('Base não iniciada',18,1)
begin try 
begin transaction

declare @escola varchar(6)
select @escola=nome from Escola

Insert into  dbo.UC
Values (@escola,@sigla,@descricao,@creditos)

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
IF OBJECT_ID ( 'dbo.sp_deleteUC', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_deleteUC;  
go

CREATE PROCEDURE dbo.sp_deleteUC
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

DELETE FROM dbo.UC
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
IF OBJECT_ID ( 'dbo.sp_updateUC', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_updateUC;  
go

CREATE PROCEDURE dbo.sp_updateUC
@id int,@sigla varchar(6),@descricao varchar(256),@creditos varchar(6)

AS 

if @id is null  or @sigla is null or @creditos is null
    raiserror('Input obrigatorio de id, sigla e creditos', 15, 1) -- with log 

SET XACT_ABORT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
declare @count int
select @count =count(*) from Escola
if (@count=0) raiserror('Base não iniciada',18,1)
begin try 
begin transaction

update dbo.UC
set sigla=@sigla,creditos=@creditos,descricao=@descricao where id=@id

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
