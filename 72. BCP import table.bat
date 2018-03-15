sqlcmd -Q "TRUNCATE TABLE DB.Schema.Table" -s "(local)"
bcp "DB.Schema.Table" in "D:\Bruce\SQLBCP\Table.bcp" -N -S "ServerName" -U sa -P password