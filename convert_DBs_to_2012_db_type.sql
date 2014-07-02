DECLARE @script VARCHAR(MAX)
DECLARE @dbname SYSNAME  
 
DECLARE db_cursor CURSOR FOR  
SELECT name 
FROM master.dbo.sysdatabases 
WHERE name NOT IN ('master','model','msdb','tempdb','ReportServer',
	'ReportServerTempDB')
	and name not like 'tmp%'
	and name not like '%tmp'
	and name not like '%__tmp__%' escape '_'
	and name not like 'test%'
	and name not like '%test'
	and name not like '%__old' escape '_'
	and name not like 'demo%'
	and name not like '%demo'
ORDER BY name
 
OPEN db_cursor   

FETCH NEXT FROM db_cursor INTO @dbname   

SET @script = ''

WHILE @@FETCH_STATUS = 0 
BEGIN  
	PRINT @dbname
	SET @script = 'ALTER DATABASE ['+@dbname+'] SET COMPATIBILITY_LEVEL = 110

'
	PRINT @script
	--exec (@script) 
	FETCH NEXT FROM db_cursor INTO @dbname   
	
END 



CLOSE db_cursor   
DEALLOCATE db_cursor
