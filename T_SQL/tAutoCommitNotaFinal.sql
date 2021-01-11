use SI2_Fase1;

Alter database SI2_Fase1 set RECURSIVE_TRIGGERS off
go
CREATE TRIGGER AutoCompleteCourse
ON dbo.Notas  
AFTER INSERT

as
	declare @total_final int,@curso varchar(6),@temp_insc int,@total_atual int, @aluno int,@ano int,@media float
	SELECT TOP 1 @temp_insc=inscrito FROM dbo.Notas ORDER BY id DESC
	select @curso=dbo.Matricula.curso,@aluno = Matricula.aluno from Notas,Inscricao,Matricula where @temp_insc=Inscricao.id and Inscricao.matricula=Matricula.id
	select @total_final = dbo.TotalCreditos(@curso)
	select @total_atual=sum(UC.creditos),@media = cast(sum(Notas.nota)as float)/cast(count(UC.creditos)as float) from Notas,Matricula,Inscricao,Oferta,UC where Matricula.aluno=@aluno and Matricula.curso=@curso and Inscricao.matricula=Matricula.id and Notas.inscrito=Inscricao.id and Inscricao.oferta = Oferta.id and Oferta.uc=UC.sigla
	select top 1 @ano=ano from Matricula where aluno=@aluno and curso=@curso ORDER BY ano DESC
	if(@total_atual=@total_final)
		insert into NotaFinal values(@aluno,@ano,@curso, round(@media,2))
	
GO  
