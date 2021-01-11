--Stored Procedure que cria a estrutura geral de um curso
use SI2_Fase1;

IF OBJECT_ID ( 'dbo.sp_createCurso', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_createCurso;  
go

CREATE PROCEDURE dbo.sp_createCurso
@dep_sigla varchar(6),@cur_sigla varchar(6),@descricao varchar(256)

AS 

if @cur_sigla is null or @dep_sigla is null 
    raiserror('Input obrigatorio de sigla de departamento e sigla de curso', 15, 1) -- with log 

SET XACT_ABORT ON
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
declare @count int
select @count =count(*) from Escola
if (@count=0) raiserror('Base não iniciada',18,1)
begin try 
begin transaction
if not exists (select 1 from dbo.Departamento where sigla=@dep_sigla)EXEC	[dbo].[sp_insertDepartamento]@escola = 'ISEL',@sigla = @dep_sigla,@descricao = NULL ;
if not exists (select 1 from dbo.Curso where sigla=@cur_sigla)insert into dbo.Curso values(@cur_sigla,@descricao) ;
insert into dbo.Curso_Dep
	values(@dep_sigla,@cur_sigla)

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

