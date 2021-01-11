use SI2_Fase1;

IF OBJECT_ID ( 'dbo.sp_GetParams', 'P' ) IS NOT NULL   
    DROP PROCEDURE dbo.sp_GetParams;  
GO  

CREATE PROCEDURE dbo.sp_GetParams  
@sp varchar(256)
AS  
if(@sp!='sp_Catch_errors' and @sp != 'sp_GetParams' and @sp != 'sp_GetSpecifics')
select  @sp as sp,
   'Parameter_name' = name,  
   'Type'   = type_name(user_type_id),  
   'Length'   = max_length,    
   'Param_order'  = parameter_id     
  from sys.parameters where object_id = object_id(@sp)
    
Return 
GO