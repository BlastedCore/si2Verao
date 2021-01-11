--Stored Procedure que atribui uma nota de UC
use SI2_Fase1;

IF OBJECT_ID ( 'dbo.sp_insertNota', 'P' ) IS NOT NULL   
    DROP procedure dbo.sp_insertNota;  
go

CREATE PROCEDURE dbo.sp_insertNota
@aluno int,@ano int,@nota float,@uc varchar(6)

AS 

if @aluno is null or @ano is null or @nota is null or @uc is null
    raiserror('Input obrigatorio de nºaluno,sigla de uc, ano e nota', 15, 1) -- with log 

SET XACT_ABORT ON
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
declare @count int
select @count =count(*) from Escola
if (@count=0) raiserror('Base não iniciada',18,1)
begin try 
begin transaction
declare @temp_matri int,@temp_ofer int, @temp_cur varchar(6), @temp_Insc int
if not exists (select 1 from dbo.Matricula where aluno=@aluno and ano=@ano) raiserror('Aluno não matriculado nesse ano',15,1)
else select @temp_matri=id, @temp_cur=curso from dbo.Matricula where aluno=@aluno and ano=@ano
if not exists(select 1 from dbo.Oferta where uc=@uc and curso=@temp_cur) raiserror('Combinação de Curso/UC não existe',15,1)
else select @temp_ofer=id from dbo.Oferta where uc=@uc and curso=@temp_cur
if not exists (select 1 from dbo.Inscricao where matricula=@temp_matri and oferta=@temp_ofer) raiserror('Aluno não inscrito nessa UC',15,1)
else select @temp_Insc=id from dbo.Inscricao where matricula=@temp_matri and oferta=@temp_ofer
insert into dbo.Notas values(@temp_Insc,@nota) 
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
