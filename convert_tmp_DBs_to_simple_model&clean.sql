USE master; 

DECLARE @script VARCHAR(MAX)
DECLARE @dbname SYSNAME  
 
DECLARE db_cursor CURSOR FOR  
SELECT name 
FROM master.dbo.sysdatabases 
WHERE name in ('some_base1','some_base1')
	or name like '%tmp'
	or name like 'tmp%'
	or name like '%_tmp_%' ESCAPE '_'
	or name like '%_test'
	or name like '%_old'

 
OPEN db_cursor   

FETCH NEXT FROM db_cursor INTO @dbname   

SET @script = ''

WHILE @@FETCH_STATUS = 0 
BEGIN  

	  PRINT @dbname
	  SET @script = 'USE ['+ @dbname +']
	  ALTER DATABASE ['+ @dbname +'] SET RECOVERY SIMPLE WITH NO_WAIT
	  DBCC SHRINKFILE (N''EmptyBase_log'' , 0, TRUNCATEONLY)'
	  FETCH NEXT FROM db_cursor INTO @dbname
	  PRINT @script
	  EXEC (@script)
END 



CLOSE db_cursor   
DEALLOCATE db_cursor
