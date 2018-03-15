--Step 1, execute below command to find out the target record
sp_who2 

--Select the details by filter database id
SELECT * FROM sys.dm_exec_requests where database_id = 5