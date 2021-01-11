--obter nºAlunos que tendo feito a sua primeira matricula num dado curso, ha mais de 3 anos, ainda nao acabaram
use SI2_Fase1;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
begin transaction
declare @curso varchar(6)
select @curso = ''--inserir sigla de curso

select Matricula.aluno 
	from Matricula,NotaFinal 
	where Matricula.ano between 0 and YEAR(GETDATE())-3 and NotaFinal.aluno=Matricula.aluno and NotaFinal.curso = @curso group by Matricula.aluno
commit
