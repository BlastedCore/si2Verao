--Stored Procedure que lista todas as UC sem inscrição entre 2 anos 
use SI2_Fase1;

IF OBJECT_ID ( 'dbo.sp_noInsc2y', 'P' ) IS NOT NULL   
    DROP procedure dbo.sp_noInsc2y;  
go

CREATE PROCEDURE dbo.sp_noInsc2y
@ano1 int,@ano2 int

AS 

if @ano1 is null or @ano2 is null or @ano1>@ano2 or @ano1<0 
	raiserror('Input obrigatorio de dois anos (yyyy), sendo o primeiro menor que o segundo', 15, 1) -- with log 

SET XACT_ABORT ON
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
declare @count int
select @count =count(*) from Escola
if (@count=0) raiserror('Base não iniciada',18,1)
begin try 
begin transaction
SELECT UC.sigla,Matricula.ano FROM Oferta,UC,Inscricao,Matricula
	where Matricula.ano between @ano1 and @ano2 and Inscricao.matricula=Matricula.id and Inscricao.oferta=Oferta.id and UC.sigla!=Oferta.uc GROUP BY sigla,ano
except
SELECT UC.sigla,Matricula.ano FROM Oferta,UC,Inscricao,Matricula
	where Matricula.ano between @ano1 and @ano2 and Inscricao.matricula=Matricula.id and Inscricao.oferta=Oferta.id and Oferta.uc=UC.sigla GROUP BY sigla,ano
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
