@ECHO OFF
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%je
SET no=%ldt:~2,6%

echo All Out War 3 "Theta" Build Script
echo Written by AOSP
echo.
echo The build number is %no%.
echo.
echo Compiling ACS.

if not exist src\code\acs\ (
	mkdir src\code\acs >nul
)

utilities\acc\acc src\code\acs_source\aow2scrp.acs src\code\acs\aow2scrp.o
echo.
echo Please check for any errors...
pause

if not exist out\ (
	mkdir out >nul
) else (
	cd out
	del /F /Q *.*
	cd ..\
)

echo Packaging base...
cd src\base\
..\..\utilities\7za a -tzip ..\..\out\theta_base-%no%.pk3 *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak

echo Packaging code...
cd ..\..\
cd src\code\
..\..\utilities\7za a -tzip ..\..\out\theta_code-%no%.pk3 *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak

echo Packaging maps...
cd ..\..\
cd src\maps\
..\..\utilities\7za a -tzip ..\..\out\theta_maps-%no%.pk3 *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak

echo Packaging music...
cd ..\..\
cd src\music\
..\..\utilities\7za a -tzip ..\..\out\theta_music-%no%.pk3 *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak
pause