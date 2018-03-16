set datetimef=%date:~10,4%%date:~4,2%%date:~7,2%%time:~0,2%%time:~3,2%%time:~6,2%
SQLCMD -S "(local)" -d NUH_OTRS -U medisys -P medinno -i "TransactionLogBackup.sql" -o "%datetimef%.rpt"