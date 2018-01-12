DECLARE vendor_cur CURSOR FOR 
  SELECT d.NAME, 
         CONVERT (SMALLINT, req_spid) AS spid 
  FROM   master.dbo.syslockinfo l, 
         master.dbo.spt_values v, 
         master.dbo.spt_values x, 
         master.dbo.spt_values u, 
         master.dbo.sysdatabases d 
  WHERE  l.rsc_type = v.number 
         AND v.type = 'LR' 
         AND l.req_status = x.number 
         AND x.type = 'LS' 
         AND l.req_mode + 1 = u.number 
         AND u.type = 'L' 
         AND l.rsc_dbid = d.dbid 
         AND rsc_dbid = (SELECT TOP 1 dbid 
                         FROM   master..sysdatabases 
                         WHERE  NAME LIKE 'piSHaRe_20161206') 
DECLARE @dbname       VARCHAR(100), 
        @spid         VARCHAR(10), 
        @kill_process NVARCHAR(1000) 

OPEN vendor_cur 
FETCH next FROM vendor_cur INTO @dbname, @spid 

WHILE @@FETCH_STATUS = 0 
  BEGIN 
      SET @kill_process = 'KILL ' + @spid 
      EXEC master.dbo.Sp_executesql @kill_process 
      PRINT 'killed spid : ' + @spid 
      FETCH next FROM vendor_cur INTO @dbname, @spid 
  END 

CLOSE vendor_cur 
DEALLOCATE vendor_cur 