SELECT P.spid, 
       RIGHT(CONVERT(VARCHAR, Dateadd(ms, Datediff(ms, P.last_batch, Getdate()),'1900-01-01'), 121), 12) AS 'batch_duration', 
       P.program_name, 
       P.hostname, 
       P.loginame 
FROM   master.dbo.sysprocesses P 
WHERE  P.spid > 50 
       AND P.status NOT IN ('background','sleeping') 
       AND P.cmd NOT IN ('AWAITING COMMAND','MIRROR HANDLER','LAZY WRITER','CHECKPOINT SLEEP','RA MANAGER') 
ORDER  BY batch_duration DESC 