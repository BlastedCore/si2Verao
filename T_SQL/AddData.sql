use SI2_Fase1;
go
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
begin transaction
--Escola
Insert into dbo.Escola Values('ISEL') 
--Pessoas
Insert into dbo.Pessoa Values('ISEL',2031,'Teste aluno1') 
Insert into dbo.Pessoa Values('ISEL',2032,'Teste aluno2') 
Insert into dbo.Pessoa Values('ISEL',2033,'Teste prof1') 
Insert into dbo.Pessoa Values('ISEL',2034,'Teste prof2') 
Insert into dbo.Pessoa Values('ISEL',2035,'Teste aluno3') 
--Alunos
Insert into dbo.Aluno Values(2031,'morada de aluno',cast('1995-01-21' as date)) 
Insert into dbo.Aluno Values(2032,'morada de aluno',cast('1995-01-21' as date)) 
Insert into dbo.Aluno Values(2035,'morada de aluno',cast('1995-01-21' as date)) 
--Professores
Insert into dbo.Professor Values(2033,'MAT','cat1') 
Insert into dbo.Professor Values(2034,'PROG','cat2') 
--Disciplinas
Insert into dbo.UC Values('ISEL','MAT1','Matematica 1', 6) 
Insert into dbo.UC Values('ISEL','MAT2','Matematica 2', 6) 
Insert into dbo.UC Values('ISEL','MAT3','Matematica 3', 6) 
Insert into dbo.UC Values('ISEL','MAT4','Matematica 4', 6) 
Insert into dbo.UC Values('ISEL','MAT5','Matematica 5', 6) 
Insert into dbo.UC Values('ISEL','MAT6','Matematica 6', 6) 
Insert into dbo.UC Values('ISEL','PG','Prog', 5) 
Insert into dbo.UC Values('ISEL','PG2','Prog2', 4.5) 
Insert into dbo.UC Values('ISEL','PG3','Prog3', 5.5) 
--Professore que lecionam num dado ano
Insert into dbo.Registo_Prof_Ano Values(1,'MAT1',2020) 
Insert into dbo.Registo_Prof_Ano Values(1,'MAT2',2020) 
Insert into dbo.Registo_Prof_Ano Values(1,'MAT3',2020) 
Insert into dbo.Registo_Prof_Ano Values(1,'MAT4',2020) 
Insert into dbo.Registo_Prof_Ano Values(1,'MAT5',2020) 
Insert into dbo.Registo_Prof_Ano Values(1,'MAT6',2020) 
Insert into dbo.Registo_Prof_Ano Values(2,'PG',2020) 
--Regentes
Insert into dbo.Registo_Regente_Ano Values(1,'MAT1',2020) 
Insert into dbo.Registo_Regente_Ano Values(1,'MAT2',2020) 
Insert into dbo.Registo_Regente_Ano Values(1,'MAT3',2020) 
Insert into dbo.Registo_Regente_Ano Values(1,'MAT4',2020) 
Insert into dbo.Registo_Regente_Ano Values(1,'MAT5',2020) 
Insert into dbo.Registo_Regente_Ano Values(1,'MAT6',2020) 
Insert into dbo.Registo_Regente_Ano Values(2,'PG',2020) 
--Departamentos
Insert into dbo.Departamento Values('ISEL','IT','Departamento de Tecnologia') 
--Cursos
Insert into dbo.Curso Values('LEIC','LICENCIATURA ENGENHARIA INFORMATICA E COMPUTADORES') 
--Cursos em departamentos
Insert into dbo.Curso_Dep Values('IT','LEIC') 
--oferta de uc em cursos 
Insert into dbo.Oferta Values('LEIC','MAT1', 1) 
Insert into dbo.Oferta Values('LEIC','MAT2', 1) 
Insert into dbo.Oferta Values('LEIC','MAT3', 1) 
Insert into dbo.Oferta Values('LEIC','MAT4', 1) 
Insert into dbo.Oferta Values('LEIC','MAT5', 1) 
Insert into dbo.Oferta Values('LEIC','MAT6', 1) 
Insert into dbo.Oferta Values('LEIC','PG', 1) 
--Criar secções
Insert into dbo.Seccao Values('sec1','seccao inicial', 'IT') 
--Professores pertencentes a cada Secção
Insert into dbo.Prof_Seccao Values(1,'sec1') 
Insert into dbo.Prof_Seccao Values(2,'sec1') 
--coordenador de cada secao
Insert into dbo.Coord_Seccao Values(1,'sec1') 
--Matriculas de alunos em ofertas
Insert into dbo.Matricula Values(1,'LEIC',2020) 
Insert into dbo.Matricula Values(2,'LEIC',2020) 
Insert into dbo.Matricula Values(3,'LEIC',2015) 
--inscrições em ofertas
Insert into dbo.Inscricao Values(1,1) 
Insert into dbo.Inscricao Values(1,2) 
Insert into dbo.Inscricao Values(1,3) 
Insert into dbo.Inscricao Values(1,4)
Insert into dbo.Inscricao Values(2,1) 
Insert into dbo.Inscricao Values(2,3)
Insert into dbo.Inscricao Values(3,1)
Insert into dbo.Inscricao Values(3,2)
Insert into dbo.Inscricao Values(3,3)
Insert into dbo.Inscricao Values(3,4)
Insert into dbo.Inscricao Values(3,5)
Insert into dbo.Inscricao Values(3,6)
--Finalização de UC's
Insert into dbo.Notas Values(1,10)
Insert into dbo.Notas Values(2,10)
Insert into dbo.Notas Values(3,10)
Insert into dbo.Notas Values(4,10)
Insert into dbo.Notas Values(5,10)
Insert into dbo.Notas Values(6,10)
Insert into dbo.Notas Values(7,10)
Insert into dbo.Notas Values(8,10)
Insert into dbo.Notas Values(9,12)
Insert into dbo.Notas Values(10,16)
Insert into dbo.Notas Values(11,11)
Insert into dbo.Notas Values(12,15)

commit


