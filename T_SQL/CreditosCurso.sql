--View CreditosCurso
use SI2_Fase1;


IF OBJECT_ID ( 'dbo.CreditosCurso', 'V' ) IS NOT NULL   
    DROP view dbo.CreditosCurso;  
go

create view dbo.CreditosCurso as
select Oferta.curso as cur,Oferta.uc as disciplina,UC.creditos as cred 
from Oferta,UC
where Oferta.uc=UC.sigla

go
--teste update e select
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
begin transaction
declare @newcred float,@curso varchar(6),@uc varchar(6)
select @newcred=5.5,@curso ='LEIC',@uc='Mat2'

update CreditosCurso set cred = @newcred where cur=@curso and disciplina=@uc 
select * from CreditosCurso 
commit