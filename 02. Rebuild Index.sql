IF Object_id('tempdb..#work_to_do') IS NOT NULL 
DROP TABLE tempdb..#work_to_do 
begin try 
  --BEGIN TRAN 
  SET nocount ON; 
  declare @objectid       int; 
  declare @indexid        int; 
  declare @partitioncount bigint; 
  declare @schemaname     nvarchar(130); 
  declare @objectname     nvarchar(130); 
  declare @indexname      nvarchar(130); 
  declare @partitionnum   bigint; 
  declare @partitions     bigint; 
  declare @frag float; 
  declare @pagecount          int; 
  declare @command            nvarchar(4000); 
  declare @page_count_minimum smallint 
  SET @page_count_minimum = 50 
  DECLARE @fragmentation_minimum float 
  SET @fragmentation_minimum = 5.0 
  DECLARE @fragmentation_rebuild_minimum float 
  SET @fragmentation_rebuild_minimum = 30.0 
  DECLARE @FILLFACTOR int 
  SET @FILLFACTOR = 80 
  -- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function 
  -- and convert object and index IDs to names. 
  SELECT   object_id                    AS objectid , 
           index_id                     AS indexid , 
           partition_number             AS partitionnum , 
           avg_fragmentation_in_percent AS frag , 
           page_count                   AS page_count 
  INTO     #work_to_do 
  FROM     sys.dm_db_index_physical_stats(db_id(), NULL, NULL, NULL, 'LIMITED') 
  WHERE    index_id > 0 
  AND      page_count > @page_count_minimum 
  AND      avg_fragmentation_in_percent > @fragmentation_minimum 
  ORDER BY page_count; 
   
  if cursor_status('global', 'partitions') >= -1 
  BEGIN 
    PRINT 'partitions CURSOR DELETED' ; 
    close partitions 
    DEALLOCATE partitions 
  END 
  -- Declare the cursor for the list of partitions to be processed. 
  DECLARE partitions CURSOR local FOR 
  SELECT * 
  FROM   #work_to_do; 
   
  -- Open the cursor. 
  open partitions; 
  -- Loop through the partitions. 
  while ( 1 = 1 ) 
  BEGIN; 
    FETCH next 
    FROM  partitions 
    INTO  @objectid, 
          @indexid, 
          @partitionnum, 
          @frag, 
          @pagecount; 
     
    if @@FETCH_STATUS < 0 BREAK; 
    select @objectname = quotename(o.NAME), @schemaname = quotename(s.NAME) 
    FROM   sys.objects AS o 
    JOIN   sys.schemas AS s ON     s.schema_id = o.schema_id 
    WHERE  o.object_id = @objectid; 
     
    select @indexname = quotename(NAME) 
    FROM   sys.indexes 
    WHERE  object_id = @objectid 
    AND    index_id = @indexid; 
     
    select @partitioncount = count(*) 
    FROM   sys.partitions 
    WHERE  object_id = @objectid 
    AND    index_id = @indexid; 
     
    set @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname 
    IF (@frag >= @fragmentation_rebuild_minimum) 
    SET @command = @command + N' REBUILD ' + ' WITH ( ' + 'FILLFACTOR = ' + CONVERT(varchar(3),@FILLFACTOR) + ' , SORT_IN_TEMPDB = ON ' + ')'
    IF (@frag < @fragmentation_rebuild_minimum) 
    SET @command = @command + N' REORGANIZE' 
    IF @partitioncount > 1 
    SET @command = @command + N' PARTITION=' + cast(@partitionnum AS nvarchar(10)); 
    begin try 
      PRINT (@command); --uncomment for testing 
      print N'Rebuilding index ' + @indexname + ' on table ' + @objectname; 
      print N'  Fragmentation: ' + cast(@frag AS      varchar(15)); 
      print N'  Page Count:    ' + cast(@pagecount AS varchar(15)); 
      print N'...'; 
      --EXEC (@command); -- uncomment to do actual rebuilding 
      print N'Done '; 
      print N' '; 
    end try 
    BEGIN catch 
      --ROLLBACK TRAN 
      PRINT 'ERROR ENCOUNTERED:' + error_message() 
      PRINT N' '; 
    end catch 
  END; 
  -- Close and deallocate the cursor. 
  close partitions; 
  deallocate partitions; 
  -- Drop the temporary table. 
  drop TABLE #work_to_do; 
   
  --COMMIT TRAN 
end try 
BEGIN catch 
  --ROLLBACK TRAN 
  PRINT 'ERROR ENCOUNTERED:' + error_message() 
END catch