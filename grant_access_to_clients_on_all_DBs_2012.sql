DECLARE @basescript VARCHAR(MAX)
DECLARE @dbname SYSNAME, @spname sysname  

DECLARE db_cursor CURSOR FOR  
SELECT s.name 
FROM master.sys.sysdatabases s
WHERE name NOT IN ('master','model','msdb','tempdb','ReportServer','ReportServerTempDB')
	and s.name not like 'tmp%'
	and s.name not like '%tmp'
	and s.name not like '%__tmp__%' escape '_'
	and s.name not like 'test%'
	and s.name not like '%test'
	and s.name not like '%__old' escape '_'
	and s.name not like 'demo%'
	and s.name not like '%demo'
 
OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @dbname   

SET @basescript = ''

WHILE @@FETCH_STATUS = 0 
BEGIN  
	  PRINT @dbname
	DECLARE db_cursor1 CURSOR FOR  
	  SELECT NAME
	 FROM sys.server_principals sp
	  WHERE sp.name LIKE ('client%')
 
	OPEN db_cursor1   
	FETCH NEXT FROM db_cursor1 INTO @spname   

	WHILE @@FETCH_STATUS = 0 
	BEGIN  
	  SET @basescript = 'use [' + @dbname + ']
	  
	IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE UPPER(name) = UPPER(N'''+@spname+'''))
		CREATE USER ['+@spname+'] FOR LOGIN ['+@spname+']
	else
		alter USER ['+@spname+'] with LOGIN = ['+@spname+'] 
	ALTER ROLE [db_datareader] ADD MEMBER ['+ @spname +']
	ALTER ROLE [db_datawriter] ADD MEMBER ['+ @spname +']
	'

	 
		PRINT @basescript
		exec (@basescript)
			FETCH NEXT FROM db_cursor1 INTO @spname   
	END 

	CLOSE db_cursor1   
	DEALLOCATE db_cursor1
     FETCH NEXT FROM db_cursor INTO @dbname   
END 

CLOSE db_cursor   
DEALLOCATE db_cursor
