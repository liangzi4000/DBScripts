@ECHO OFF
for /f "usebackq delims=" %%i in (`dir *.sql /s /b`) do (
rem  echo %%i.csv
  SQLCMD -S "." -d piSHaRe_20161206 -i "%%i" -o "%%i.rpt"
  Echo Completed Script: %%i
)
pause