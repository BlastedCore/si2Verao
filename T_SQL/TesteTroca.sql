use SI2_Fase1

--Verificar sempre durante o processo se: 1)é possivel aceder aos dados, 2)é possivel correr instruções
select * from UC

--teste #1, executar o seguinte codigo antes de iniciar o processo no visual studio
delete from UC where sigla=N'PG2'

--teste #2, executar o seguinte codigo duas vezes, uma no passo "PONTO" marcado em codigo na classe Troca e outra vez antes de 
update UC set creditos = 3 where sigla=N'PG2'

--teste #3, executar o seguinte codigo duas vezes, uma com commit e outra sem no passo "PONTO" marcado em codigo na classe Troca
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
begin transaction   

delete from UC where sigla=N'PG2'
--primeira vez não fazer commit e apenas continuar o processo no visual studio
commit 


--teste #4, executar o seguinte codigo duas vezes, uma com commit e outra sem no passo "PONTO" marcado em codigo na classe Troca
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
begin transaction   

delete from UC where sigla=N'PG2'
delete from UC where sigla=N'PG3'
--primeira vez não fazer commit e apenas continuar o processo no visual studio
commit 


--teste #5, executar o seguinte codigo duas vezes, uma com commit e outra sem no passo "PONTO" marcado em codigo na classe Troca
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
begin transaction   

update UC set creditos = 3 where sigla=N'PG2'

--primeira vez não fazer commit e apenas continuar o processo no visual studio
commit 


--Reposição de Valores, executar de acordo com o necessário para renovar os valores iniciais
delete from UC where sigla=N'PG2'
delete from UC where sigla=N'PG3'
Insert into dbo.UC Values('ISEL','PG2','Prog2', 4.5) 
Insert into dbo.UC Values('ISEL','PG3','Prog3', 6.5) 

