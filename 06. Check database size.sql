--Get data and transaction log size and their free space
SELECT DB_NAME() AS DbName, 
name AS FileName, 
size/128.0 AS CurrentSizeMB, 
size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS FreeSpaceMB 
FROM sys.database_files; 

--Get transaction log usage information
DBCC SQLPERF(logspace) 
GO

--Get total DB size, files information
sp_helpdb 'NUH_OTRS'
GO
