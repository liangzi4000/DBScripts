@ECHO OFF
set resultFileName=result.txt
for /f "usebackq delims=" %%i in (`dir *.sql /s /b`) do (
rem  echo %%i.csv
  SQLCMD -I -S "." -d CargoClique_Kiosk -i "%%i" -o "%%i.rpt"
  Echo ------------------------------- "%%i.rpt" ------------------------------- >> %resultFileName%
  type "%%i.rpt" >> %resultFileName%
  Echo Completed Script: %%i
)
pause