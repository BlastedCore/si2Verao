--Stored Procedure que matricula alunos em cursos
use SI2_Fase1;

--INSERT
IF OBJECT_ID ( 'dbo.sp_insertMatricula', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_insertMatricula;  
go

CREATE PROCEDURE dbo.sp_insertMatricula
@aluno int,@curso varchar(6),@ano int

AS 

if @curso is null or @aluno is null or @ano is null 
    raiserror('Input obrigatorio de sigla de nºaluno, sigla de curso e ano (yyyy)', 15, 1) -- with log 

SET XACT_ABORT ON
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ

declare @count int
select @count =count(*) from Escola
if (@count=0) raiserror('Base não iniciada',18,1)
begin try 
begin transaction
if exists ((select 1 from dbo.Curso where sigla=@curso) intersect (select 1 from dbo.Aluno where nAluno=@aluno))insert into dbo.Matricula values(@aluno,@curso,@ano) 
else raiserror('Aluno ou curso não existem',15,1)
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
