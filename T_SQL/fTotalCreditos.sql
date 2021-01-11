--Function TotalCreditos
use SI2_Fase1;

IF OBJECT_ID ( 'dbo.TotalCreditos', 'FN' ) IS NOT NULL   
    DROP Function dbo.TotalCreditos;  
go

CREATE Function dbo.TotalCreditos(@curso varchar(6))
Returns int
AS 
begin
declare @total int,@temp_val int,@temp_cur varchar(6)
select @total=0;
DECLARE ofe_cursor INSENSITIVE CURSOR  
    FOR SELECT Oferta.uc,UC.creditos FROM Oferta,UC
	where curso=@curso and sigla = uc
OPEN ofe_cursor  
FETCH NEXT FROM ofe_cursor into @temp_cur,@temp_val   
WHILE @@FETCH_STATUS = 0  
    BEGIN 
        SELECT @total=@temp_val +@total
        FETCH NEXT FROM ofe_cursor INTO @temp_cur,@temp_val  
    END  
CLOSE ofe_cursor  
DEALLOCATE ofe_cursor  
return @total
end


