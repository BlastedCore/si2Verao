--Stored Procedure que iscreve um aluno numa UC num dado ano 
use SI2_Fase1;

IF OBJECT_ID ( 'dbo.sp_insertInscricao', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_insertInscricao;  
go

CREATE PROCEDURE dbo.sp_insertInscricao
@aluno int,@uc varchar(6),@ano int

AS 

if @aluno is null or @uc is null or @ano is null 
    raiserror('Input obrigatorio de sigla de aluno, sigla de UC e ano', 15, 1) -- with log 

SET XACT_ABORT ON
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
declare @count int
select @count =count(*) from Escola
if (@count=0) raiserror('Base não iniciada',18,1)
begin try 
begin transaction
declare @temp_matri int,@temp_ofer int, @temp_cur varchar(6)
if not exists (select 1 from dbo.Matricula where aluno=@aluno and ano=@ano) raiserror('Aluno não matriculado nesse ano',15,1)
else select @temp_matri=id, @temp_cur=curso from dbo.Matricula where aluno=@aluno and ano=@ano
if not exists(select 1 from dbo.Oferta where uc=@uc and curso=@temp_cur) raiserror('Combinação de Curso/UC não existe',15,1)
else select @temp_ofer=id from dbo.Oferta where uc=@uc and curso=@temp_cur
insert into dbo.Inscricao values(@temp_matri,@temp_ofer) 

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

