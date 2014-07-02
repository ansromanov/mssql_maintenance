DECLARE @basescript VARCHAR(MAX)
DECLARE @dbname SYSNAME  

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
	  SET @basescript = 'use [' + @dbname + ']
	  '
	  SELECT @basescript = @basescript +  '
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE UPPER(name) = UPPER(N'''+name+'''))
CREATE USER ['+name+'] FOR LOGIN ['+name+'] 
ALTER ROLE [db_owner] ADD MEMBER ['+ name +']
ALTER ROLE [db_securityadmin] ADD MEMBER ['+ name +']
ALTER ROLE [db_datareader] ADD MEMBER ['+ name +']
ALTER ROLE [db_datawriter] ADD MEMBER ['+ name +']
'
	 FROM sys.server_principals sp
	 WHERE sp.name in ('contoso\admin1','contoso\admin1')

	 PRINT @basescript
	 exec (@basescript)
     FETCH NEXT FROM db_cursor INTO @dbname   
END 

CLOSE db_cursor   
DEALLOCATE db_cursor
