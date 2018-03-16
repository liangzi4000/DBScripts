DECLARE @BackupFileName varchar(100)
SET @BackupFileName = N'D:\DB\Backup\NUH OTRS\NUH_OTRS-Transaction-Log-'+CONVERT(char(8),GETDATE(),112)+REPLACE(CONVERT(varchar(10),GETDATE(),108),':','')+'.trn'
BACKUP LOG [NUH_OTRS] TO  DISK = @BackupFileName WITH NOFORMAT, NOINIT,  NAME = N'NUH_OTRS-Transaction Log  Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
GO


