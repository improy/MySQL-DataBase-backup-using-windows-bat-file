@echo off

:: make sure to change the settings from line 4-9
set dbUser=root
set dbPassword=""
set backupDir="D:\Localhost_MySQL_Backup"
set mysqldump="D:\wamp\bin\mysql\mysql5.7.14\bin\mysqldump.exe"
set mysqlDataDir="D:\wamp\bin\mysql\mysql5.7.14\data"
set zip="C:\Program Files\7-Zip\7z.exe"

:: get date
for /F "tokens=2-4 delims=/ " %%i in ('date /t') do (
	set mm=%%i
	set dd=%%j
	set yy=%%k
)

if %mm%==01 set Month="Jan"
if %mm%==02 set Month="Feb"
if %mm%==03 set Month="Mar"
if %mm%==04 set Month="Apr"
if %mm%==05 set Month="May"
if %mm%==06 set Month="Jun"
if %mm%==07 set Month="Jul"
if %mm%==08 set Month="Aug"
if %mm%==09 set Month="Sep"
if %mm%==10 set Month="Oct"
if %mm%==11 set Month="Nov"
if %mm%==12 set Month="Dec"

set dirName=%dd%_%Month%_%yy%
set fileSuffix=%dd%-%Month%-%yy%

:: remove echo here if you like
echo "dirName"="%dirName%"

:: switch to the "data" folder
pushd "%mysqlDataDir%"

:: create backup folder if it doesn't exist
if not exist %backupDir%\%dirName%\   mkdir %backupDir%\%dirName%

:: iterate over the folder structure in the "data" folder to get the databases
for /d %%f in (*) do (
	:: remove echo here if you like
	echo processing folder "%%f"

	%mysqldump% --host="localhost" --user=%dbUser% --password=%dbPassword% --single-transaction --add-drop-table --databases %%f > %backupDir%\%dirName%\%%f.sql
	%zip% a -tgzip %backupDir%\%dirName%\%fileSuffix%_%%f.sql.gz %backupDir%\%dirName%\%%f.sql
	del %backupDir%\%dirName%\%%f.sql
)
popd
