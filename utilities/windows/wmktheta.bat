@ECHO OFF
title All Out War: Theta Build Script

SET START=%CD%

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
    echo Note: Tools will run in 32-bit mode!
    title All Out War: Theta Build Script [32-bit]
    SET ARCH=32
)
IF /I "%1"=="/FORCEWIN64" (
    echo Note: Tools will run in 64-bit mode!
    title All Out War: Theta Build Script [64-bit]
    SET ARCH=64
)

IF /I "%2"=="/NOPAUSE" (
    SET USEPAUSE=0
) ELSE (
    SET USEPAUSE=1
)

IF /I "%3"=="/NOGIT" (
    SET NOGIT=1
) ELSE (
    git >nul 2>&1
    if %errorlevel%==9009 (
        SET NOGIT=1
    ) else (
        SET NOGIT=0
    )
)

echo All Out War "Theta" Build Script
echo Written by Sean
echo.

IF %NOGIT%==0 (
    "%START%\utilities\windows\win%ARCH%\gitcommit.exe" batch "%START%\utilities\commit.bat" --silent
    ::if not %errorlevel%==0 goto exefail
    call "%START%\utilities\commit.bat"
)

"%START%\utilities\windows\win%ARCH%\genver.exe" "%START%\version.h" batch "%START%\utilities\version.bat" --silent
if not %errorlevel%==0 goto exefail
CALL "%START%\utilities\version.bat"
"%START%\utilities\windows\win%ARCH%\genver.exe" "%START%\version.h" c "%START%\src\code\acs_src\version.acs" --silent
if not %errorlevel%==0 goto exefail

echo You are building %VERSION_STRING%.
IF %NOGIT%==0 echo You are building commit %COMMIT_HASH%.

IF %NOGIT%==0 SET no=-%VERSION_STRING%-%COMMIT_HASH%
IF NOT %NOGIT%==0 SET no=-%VERSION_STRING%

IF /I "%1"=="/NOVERSION" (
    SET no=
)

echo.

if not exist src\code\acs\ (
	mkdir src\code\acs >nul
)

:::::: We don't have a changelog!!
::echo Generating ACS changelog.
::cd src\code\acs_src
::"%START%\utilities\windows\win%ARCH%\acschangelog.exe" "%START%\changelog.txt" "%START%\src\code\acs_src\a_changelog.acs"
::if not %errorlevel%==0 goto exefail
:: %START%\utilities\acver "a_version.acs" "%START%"

:: Make an .acs with commit info.

IF %NOGIT%==0 (
    "%START%\utilities\windows\win%ARCH%\gitcommit.exe" c "%START%\src\code\acs_src\gitcommit.acs" --silent
    if not %errorlevel%==0 goto exefail
)

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
"%START%\utilities\windows\win%ARCH%\7za.exe" a -tzip "%START%\out\theta_base%no%.pk3" *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak
if not %errorlevel%==0 goto exefail

echo Packaging code...
cd ..\..\
cd src\code\
"%START%\utilities\windows\win%ARCH%\7za.exe" a -tzip "%START%\out\theta_code%no%.pk3" *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak
if not %errorlevel%==0 goto exefail

echo Packaging maps...
cd ..\..\
cd src\maps\
"%START%\utilities\windows\win%ARCH%\7za.exe" a -tzip "%START%\out\theta_maps%no%.pk3" *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak
if not %errorlevel%==0 goto exefail

echo Packaging music...
cd ..\..\
cd src\music\
"%START%\utilities\windows\win%ARCH%\7za.exe" a -tzip "%START%\out\theta_music%no%.pk3" *.* -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak
if not %errorlevel%==0 goto exefail

echo Cleaning up...
IF EXIST "%START%\utilities\commit.bat" del /F /Q "%START%\utilities\commit.bat"

cd %start%
echo.
IF %NOGIT%==0 echo Built Theta %VERSION_STRING%-%COMMIT_HASH% successfully!
IF NOT %NOGIT%==0 echo Built Theta %VERSION_STRING% successfully!
echo.
echo The PK3 files are to be found in:
echo %START%\out

title All Out War: Theta Build Success
echo.
if %USEPAUSE%==1 (
    echo Press any key to exit the build script.
    pause >nul
)
exit 0

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: GO TO HERE WHEN %ERRORLEVEL% != 0 ! ::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:exefail
title All Out War: Theta Build Failed
echo Something somewhere has gone wrong, and Theta could not be built.
echo Command returned error code %ERRORLEVEL%.
echo.
if %USEPAUSE%==1 echo Press any key to exit.
if %USEPAUSE%==1 pause >nul
exit 1
