USE [master]
RESTORE DATABASE [NUH_OTRS_Test_Restore] 
FROM  DISK = N'D:\Database\NUH\TestDBRestore\NUH_OTRS-Full-20180317.bak' WITH  FILE = 1,  
MOVE N'NUH_OTRS' TO N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\NUH_OTRS_test_restore.mdf',  
MOVE N'NUH_OTRS_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\NUH_OTRS_test_restore.ldf',  
NORECOVERY,  NOUNLOAD,  STATS = 5

GO


