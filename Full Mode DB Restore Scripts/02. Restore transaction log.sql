RESTORE LOG [NUH_OTRS_Test_Restore] 
FROM  DISK = N'D:\Database\NUH\TestDBRestore\NUH_OTRS-Transaction-Log-20180317230000.trn' WITH  FILE = 1,  
NOUNLOAD,  STATS = 10
GO
