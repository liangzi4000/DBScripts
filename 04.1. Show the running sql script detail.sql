DECLARE @spid       INT, 
        @stmt_start INT, 
        @stmt_end   INT, 
        @sql_handle BINARY(20) 

SET @spid = xxx -- Fill this in 

SELECT TOP 1 @sql_handle = sql_handle, 
             @stmt_start = CASE stmt_start 
                             WHEN 0 THEN 0 
                             ELSE stmt_start / 2 
                           END, 
             @stmt_end = CASE stmt_end 
                           WHEN -1 THEN -1 
                           ELSE stmt_end / 2 
                         END 
FROM   master.dbo.sysprocesses 
WHERE  spid = @spid 
ORDER  BY ecid 

SELECT Substring(text, COALESCE(NULLIF(@stmt_start, 0), 1), 
CASE @stmt_end 
    WHEN -1 THEN Datalength(text) 
    ELSE (@stmt_end - @stmt_start) 
END)
FROM   ::fn_get_sql(@sql_handle) 
