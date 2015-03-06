@ECHO OFF
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%je
SET no=%ldt:~2,6%
SET start=%cd%

echo All Out War "Theta" Build Script
echo Written by AOSP
echo.
echo The build number is %no%.
echo.
echo Compiling ACS.

if not exist src\code\acs\ (
	mkdir src\code\acs >nul
)

cd src\code\acs_src
%start%\utilities\acschangelog.exe %start%\changelog.txt %start%\src\code\acs_src\a_changelog.acs
:: %start%\utilities\acver "a_version.acs" "%start%"

cd %start%
%start%\utilities\acc\acc %start%\src\code\acs_src\aow2scrp.acs %start%\src\code\acs\aow2scrp.o
echo.
echo Please check for any errors...
pause
%start%\utilities\acsconstants.exe %start%\src\code\acs_src\aow2scrp.acs %start%\src\code\actors\acsconstants.dec

if not exist out\ (
	mkdir out >nul
) else (
	cd out
	del /F /Q *.*
	cd ..\
)

echo Packaging base...
cd src\base\
%start%\utilities\7za a -tzip %start%\out\theta_base-%no%.pk3 *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak

echo Packaging code...
cd ..\..\
cd src\code\
%start%\utilities\7za a -tzip %start%\out\theta_code-%no%.pk3 *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak

echo Packaging maps...
cd ..\..\
cd src\maps\
%start%\utilities\7za a -tzip %start%\out\theta_maps-%no%.pk3 *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak

echo Packaging music...
cd ..\..\
cd src\music\
..\..\utilities\7za a -tzip %start%\out\theta_music-%no%.pk3 *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak
pause