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
	mkdir acs >nul
)

utilities\acc\acc src\code\acs_source\aow2scrp.acs src\code\acs\aow2scrp.o
echo.
echo Please check for any errors...
pause

if not exist out\ (
	mkdir out >nul
)

echo Packaging base...
utilities\7za a -tzip out\theta_base-%no%.pk3 src\base\*.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak

echo Packaging code...
utilities\7za a -tzip out\theta_code-%no%.pk3 src\code\*.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak

echo Packaging maps...
utilities\7za a -tzip out\theta_maps-%no%.pk3 src\maps\*.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak

echo Packaging music...
utilities\7za a -tzip out\theta_music-%no%.pk3 src\music\*.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak
pause