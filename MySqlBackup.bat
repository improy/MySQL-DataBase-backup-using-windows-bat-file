@echo off

 set dbUser=root
 set dbPassword=password-if-any
 set backupDir="D:\LOCALHOST_MySQL_DB_Backup\"
 set mysqldump="D:\wamp\bin\mysql\mysql5.6.17\bin\mysqldump.exe"
 set mysqlDataDir="D:\wamp\bin\mysql\mysql5.6.17\data"
 set zip="C:\Program Files\7-Zip\7z.exe"

 set datetimef=%date%
 set datetimef=%datetimef: =0%
 :: if the directory structure is not correct comment the above line and uncomment the following two lines
 :: set datetimef=%datetimef: =_%
 :: set datetimef=%datetimef:/=_%

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
