@ECHO OFF
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%je
SET no=%ldt:~2,6%
SET start=%cd%

IF /I "%PROCESSOR_ARCHITECTURE%"=="x32" (
    IF NOT DEFINED PROCESSOR_ARCHITEW6432 (
        SET ARCH=32
    ) ELSE (
        SET ARCH=64
    )
) ELSE IF /I "%PROCESSOR_ARCHITECTURE%"=="x86" (
        IF NOT DEFINED PROCESSOR_ARCHITEW6432 (
            SET ARCH=32
        ) ELSE (
            SET ARCH=64
        )
) ELSE (
        SET ARCH=64
)

IF /I "%1"=="/FORCEWIN32" (
    SET ARCH=32
)

echo All Out War "Theta" Build Script
echo Written by Sean
echo.
echo The build number is %no%.
echo.

SET PATH=%PATH%;%start%\utilties;%start%\utilties\x%ARCH%;%start%\utilities\acc

echo Compiling ACS.

if not exist src\code\acs\ (
	mkdir src\code\acs >nul
)

cd src\code\acs_src
acschangelog "%start%\changelog.txt" "%start%\src\code\acs_src\a_changelog.acs"
:: %start%\utilities\acver "a_version.acs" "%start%"

cd "%start%"
acc "%start%\src\code\acs_src\aow2scrp.acs" "%start%\src\code\acs\aow2scrp.o"

if not %ERRORLEVEL%==0 (
    SET ACSError=%ERRORLEVEL%
    echo.
    echo An error occured when building the ACS.
    echo Please fix it and rebuild.
    echo.
    echo Press any key to exit.
    pause >nul
    exit %ACSError%
)

acsconstants.exe "%start%\src\code\acs_src\aow2scrp.acs" "%start%\src\code\actors\acsconstants.dec"

if not exist out\ (
	mkdir out >nul
) else (
	cd out
	del /F /Q *.*
	cd ..\
)

echo Packaging base...
cd src\base\
7za a -tzip "%start%\out\theta_base-%no%.pk3" *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak

echo Packaging code...
cd ..\..\
cd src\code\
7za a -tzip "%start%\out\theta_code-%no%.pk3" *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak

echo Packaging maps...
cd ..\..\
cd src\maps\
7za a -tzip "%start%\out\theta_maps-%no%.pk3" *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak

echo Packaging music...
cd ..\..\
cd src\music\
7za a -tzip "%start%\out\theta_music-%no%.pk3" *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak

echo The PK3 files are to be found in:
echo %start%\out

pause
