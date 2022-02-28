set PGPASSWORD=password
REM "C:\Program Files\PostgreSQL\13\bin\psql.exe" -U postgres -d ESS -c "SELECT * FROM \"CTB\".\"Department\"" > TEST.TXT
@ECHO OFF
set resultFileName=result.txt
for /f "usebackq delims=" %%i in (`dir *.sql /s /b`) do (
	"C:\Program Files\PostgreSQL\13\bin\psql.exe" -U postgres -d ESS -f "%%i" > "%%i.rpt"
	Echo ------------------------------- "%%i.rpt" ------------------------------- >> %resultFileName%
	type "%%i.rpt" >> %resultFileName%
	Echo Completed Script: %%i
)
pause
