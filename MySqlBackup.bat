@echo off

 set dbUser=root
 set dbPassword=
 set backupDir="G:\LOCALHOST_MySQL_DB_Backup\"
 set mysqldump="G:\wamp\bin\mysql\mysql5.6.17\bin\mysqldump.exe"
 set mysqlDataDir="G:\wamp\bin\mysql\mysql5.6.17\data"
 set zip="C:\Program Files\7-Zip\7z.exe"

 set datetimef=%date%
 set datetimef=%datetimef: =0%

 echo dirName=%datetimef%
 set dirName=%datetimef%
 set fileSuffix=%datetimef%
 
 :: switch to the "data" folder
 pushd %mysqlDataDir%

 :: iterate over the folder structure in the "data" folder to get the databases
 for /d %%f in (*) do (

 if not exist %backupDir%\%dirName%\ (
      mkdir %backupDir%\%dirName%
 )

 %mysqldump% --host="localhost" --user=%dbUser% --password=%dbPassword% --single-transaction --add-drop-table --databases %%f > %backupDir%\%dirName%\%%f.sql

 %zip% a -tgzip %backupDir%\%dirName%\%fileSuffix%_%%f.sql.gz %backupDir%\%dirName%\%%f.sql

 del %backupDir%\%dirName%\%%f.sql
 )
 popd
