DECLARE @script VARCHAR(MAX)
DECLARE @dbname SYSNAME  
 
DECLARE db_cursor CURSOR FOR  
SELECT name 
FROM master.dbo.sysdatabases 
WHERE name NOT IN ('master','model','msdb','tempdb','ReportServer',
	'ReportServerTempDB')
	
OPEN db_cursor   

FETCH NEXT FROM db_cursor INTO @dbname   

SET @script = ''

WHILE @@FETCH_STATUS = 0 
BEGIN  

	  --PRINT @dbname
	  SET @script = @script + 'DBCC CHECKDB ('''+@dbname+''') WITH NO_INFOMSGS
	  
	  
	  
	  
'
	  FETCH NEXT FROM db_cursor INTO @dbname
	  
	  
END 

--PRINT @script
EXEC (@script)

CLOSE db_cursor   
DEALLOCATE db_cursor
