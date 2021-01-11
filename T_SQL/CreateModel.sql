use SI2_Fase1;

Create table dbo.Escola
(
nome varchar(256) primary key
)

Create table dbo.Pessoa 
(
escola varchar(256) references dbo.Escola(nome)ON UPDATE CASCADE,
nCont int primary key ,
nome varchar(100) not null
)

Create table dbo.Aluno
(
nAluno int IDENTITY(1,1) primary key,
nCont int unique REFERENCES  dbo.Pessoa(nCont)ON DELETE CASCADE,
morada varchar(256) not null,
dtNsc date not null check (dtNsc<GETDATE()) 
)

Create table dbo.Professor
(
nDocente int IDENTITY(1,1) primary key,
nCont int REFERENCES  dbo.Pessoa(nCont),
area varchar(256) not null,
categoria varchar(60) not null
)

Create table dbo.UC
(
id int unique IDENTITY(1,1) not null ,
escola varchar(256) references dbo.Escola(nome)ON UPDATE CASCADE,
sigla varchar(6) primary key,
descricao varchar(256),
creditos float constraint real_credit check(creditos BETWEEN 0.0 and 180.0) not null
)

Create table dbo.Registo_Prof_Ano
(
id int unique IDENTITY(1,1) not null ,
prof int references  dbo.Professor(nDocente),
uc varchar(6) references  dbo.UC(sigla)ON UPDATE CASCADE,
ano int constraint real_year_prof CHECK(ano BETWEEN 1900 and 2100 and ano<(YEAR(GETDATE())+1)),
primary key(prof,uc,ano)
)

Create table dbo.Registo_Regente_Ano
(
prof int references  dbo.Professor(nDocente),
uc varchar(6) references  dbo.UC(sigla)ON UPDATE CASCADE,
ano int constraint real_year_rege CHECK(ano BETWEEN 1900 and 2100 and ano<(YEAR(GETDATE())+1)),
primary key(ano,uc)
)

Create table dbo.Departamento
(
id int unique IDENTITY(1,1) not null ,
escola varchar(256) references dbo.Escola(nome)ON UPDATE CASCADE,
sigla varchar(6) primary key,
descricao varchar(256)
)

Create table dbo.Curso
(
sigla varchar(6) primary key,
descricao varchar(256)
)

Create table dbo.Curso_Dep
(
departamento varchar(6) references  dbo.Departamento(sigla)ON UPDATE CASCADE,
curso varchar(6) references  dbo.Curso(sigla)  ON UPDATE CASCADE primary key
)

Create table dbo.Oferta
(
id int primary key IDENTITY(1,1) not null ,
curso varchar(6) references  dbo.Curso(sigla)ON UPDATE CASCADE,
uc varchar(6) references  dbo.UC(sigla)ON UPDATE CASCADE,
semestre int constraint real_semestre check(semestre between 1 and 6)not null,
unique(curso,uc)
)

Create table dbo.Seccao
(
id int unique IDENTITY(1,1) not null ,
sigla varchar(6) primary key,
descricao varchar(256),
departamento varchar(6) references  dbo.Departamento(sigla)ON UPDATE CASCADE
) 

Create table dbo.Prof_Seccao
(
prof int references  dbo.Professor(nDocente),
seccao varchar(6) references  dbo.Seccao(sigla)ON UPDATE CASCADE
primary key(prof,seccao)
)

Create table dbo.Coord_Seccao
(
coordenador int references  dbo.Professor(nDocente),
seccao varchar(6) references  dbo.Seccao(sigla)ON UPDATE CASCADE,
primary key(coordenador,seccao)
)

Create table  dbo.Matricula
(
id int primary key IDENTITY(1,1) not null ,
aluno int references  dbo.Aluno(nAluno)ON DELETE CASCADE,
curso varchar(6) references  dbo.Curso(sigla)ON UPDATE CASCADE,
ano int constraint real_year_Matri CHECK(ano BETWEEN 1900 and 2100 and ano<(YEAR(GETDATE())+1)),
unique (ano,aluno)

)

Create table  dbo.Inscricao
(
id int primary key IDENTITY(1,1) not null ,
matricula int references  dbo.Matricula(id)ON DELETE CASCADE,
oferta int references  dbo.Oferta(id),
unique(matricula,oferta)
)

Create table  dbo.Notas
(
id int primary key IDENTITY(1,1) not null ,
inscrito int references  dbo.Inscricao(id) ON DELETE CASCADE ,
nota float constraint real_grade check(nota BETWEEN 0.0 and 20.0) not null,
)

Create table  dbo.NotaFinal
(
aluno int references  dbo.Aluno(nAluno) ON DELETE CASCADE,
ano int constraint real_year_final CHECK(ano BETWEEN 1900 and 2100 and ano<(YEAR(GETDATE())+1)),
curso varchar(6) references  dbo.Curso(sigla),
notaMed float not null,
primary key(aluno,curso)
)


--triggers adicionais
go
create trigger LimitTable
on dbo.Escola
after insert
as
    declare @tableCount int
    select @tableCount = Count(*)
    from dbo.Escola

    if @tableCount > 1
    begin
        rollback
    end
go


