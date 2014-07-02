DECLARE @script VARCHAR(MAX)
DECLARE @dbname SYSNAME  
 
DECLARE db_cursor CURSOR FOR  
SELECT name 
FROM master.dbo.sysdatabases 
WHERE  name like 'tmp%'
	or name like '%tmp'
	or name like '%__tmp__%' escape '_'
	or name like 'test%'
	or name like '%test'
	or name like '%__old' escape '_'
	or name like 'demo%'
	or name like '%demo'
ORDER BY name
 
OPEN db_cursor   

FETCH NEXT FROM db_cursor INTO @dbname   

SET @script = ''

WHILE @@FETCH_STATUS = 0 
BEGIN  
	  PRINT @dbname
	  if @script = ''
	  SET @script = 'SELECT ''' + @dbname + ''' as DBName,
	  (SELECT suser_sname( owner_sid ) FROM sys.databases
	  WHERE name=''' + @dbname + ''') as DBOwner,
	  (SELECT create_date FROM sys.databases
	  WHERE name=''' + @dbname + ''') as CreateDate,
	  MAX(t.modify_date) as LastUpdate
FROM ['+@dbname+'].sys.all_objects t
--ORDER BY LastUpdate
'
	else
	SET @script = @script + ' UNION ALL SELECT ''' + @dbname + ''' as DBName,
	(SELECT suser_sname( owner_sid ) FROM sys.databases
	   where name=''' + @dbname + ''') as DBOwner,
	(SELECT create_date FROM sys.databases
	  WHERE name=''' + @dbname + ''') as CreateDate,
	   MAX(t.modify_date) as LastUpdate
FROM ['+@dbname+'].sys.all_objects t
--ORDER BY CreateDate
'

	  PRINT ' '
	  
	  PRINT @script
      FETCH NEXT FROM db_cursor INTO @dbname   
	
END 
SET @script = @script + 'ORDER BY CreateDate'
exec (@script) 


CLOSE db_cursor   
DEALLOCATE db_cursor
