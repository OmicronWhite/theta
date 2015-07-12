@ECHO OFF
title All Out War: Theta Build Script

SET START=%CD%
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%je
SET no=%ldt:~2,6%

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

echo %START%
"%START%\utilities\windows\win%ARCH%\gitcommit.exe" batch "%START%\utilities\commit.bat" --silent
if not %errorlevel%==0 goto exefail
call "%START%\utilities\commit.bat"

echo The build number is %no%.
echo You are building commit %COMMIT_HASH%.
echo.

if not exist src\code\acs\ (
	mkdir src\code\acs >nul
)

:::::: We don't have a changelog!!
::echo Generating ACS changelog.
::cd src\code\acs_src
::"%START%\utilities\windows\win%ARCH%\acschangelog.exe" "%START%\changelog.txt" "%START%\src\code\acs_src\a_changelog.acs"
if not %errorlevel%==0 goto exefail
:: %START%\utilities\acver "a_version.acs" "%START%"

echo Compiling ACS.
cd "%START%"
"%START%\utilities\windows\acc\acc.exe" "%START%\src\code\acs_src\aow2scrp.acs" "%START%\src\code\acs\aow2scrp.o"
if not %errorlevel%==0 goto exefail

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

"%START%\utilities\windows\win%ARCH%\acsconstants.exe" "%START%\src\code\acs_src\aow2scrp.acs" "%START%\src\code\actors\acsconstants.dec"
if not %errorlevel%==0 goto exefail

if not exist out\ (
	mkdir out >nul
) else (
	cd out
	del /F /Q *.*
	cd ..\
)

echo Packaging base...
cd src\base\
"%START%\utilities\windows\win%ARCH%\7za.exe" a -t7z "%START%\out\theta_base-%no%.pk7" *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak
if not %errorlevel%==0 goto exefail

echo Packaging code...
cd ..\..\
cd src\code\
"%START%\utilities\windows\win%ARCH%\7za.exe" a -t7z "%START%\out\theta_code-%no%.pk7" *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak
if not %errorlevel%==0 goto exefail

echo Packaging maps...
cd ..\..\
cd src\maps\
"%START%\utilities\windows\win%ARCH%\7za.exe" a -t7z "%START%\out\theta_maps-%no%.pk7" *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak
if not %errorlevel%==0 goto exefail

echo Packaging music...
cd ..\..\
cd src\music\
"%START%\utilities\windows\win%ARCH%\7za.exe" a -t7z "%START%\out\theta_music-%no%.pk7" *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak
if not %errorlevel%==0 goto exefail

echo Cleaning up...
IF EXIST "%START%\utilities\commit.bat" del /F /Q "%START%\utilities\commit.bat"

echo.
echo The PK7 files are to be found in:
echo %START%\out
echo Build number #%no%.
echo Commit hash: %COMMIT_HASH%.

title All Out War: Theta Build Success
echo.
echo Press any key to exit the build script.
pause >nul
exit 0

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: GO TO HERE WHEN %ERRORLEVEL% != 0 ! ::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:exefail
title All Out War: Theta Build Failed
echo Something somewhere has gone wrong, and Theta could not be built.
echo Command returned error code %ERRORLEVEL%.
echo.
echo Press any key to exit.
pause >nul
exit 1
