@ECHO off

REM Sets up the required variables
SETLOCAL
REM Set the path of the hosts file to %HOSTS_FILE%
SET "HOSTS_FILE=%WinDir%\System32\drivers\etc\hosts"
REM Create a temporary file to make the changes too
SET "TEMP_HOSTS_FILE=%TEMP%\%RANDOM%__hosts"

GOTO intro

:intro
    REM Prints the intro message
    ECHO   ___  _             _         _^| ^|_  
    ECHO / __^|^| ^| ___  __ _ ^|^| ^|__ ___ ^|_   _^| 
    ECHO ^| (__ ^| ^|/ _ \/ _` ^|^| / /(_-/   ^|_^|   
    ECHO \___^|^|_^|\___/\__/_\^|^|_\_\/__/         
    REM Continue to admin permission checking
    GOTO permissions

:options
    REM Let the user know the options they have
    ECHO Type one of the following (use the number)
    ECHO 1) Install (Install Cloaks+ on this computer)
    ECHO 2) Uninstall (Remove Cloaks+ from the computer)
    ECHO 3) Exit (Close this application)
    REM Take in user input and store it as %OPTION%
    SET /p choice=Type the number representing an option:

    if '%choice%'=='' (
        ECHO "%choice%" is not valid, please try again.
        GOTO options
    )
    if '%choice%'=='1' GOTO install
    if '%choice%'=='2' GOTO uninstall
    if '%choice%'=='3' EXIT

:permissions
    REM This attempts to add a registry key (This will fail without admin rights)
    REM The key already exists so it will not be affected
    REG ADD HKLM /F>nul 2>&1
    if %ERRORLEVEL% == 0 (
        REM The user has admin permissions and can continue
        GOTO options
    ) else (
        REM The user does not have admin permissions, give them an error message
        ECHO ---------------------------------------------------------
        ECHO NO ADMIN PERMISSIONS
        ECHO ---------------------------------------------------------
        ECHO You did not run this with Admin permissions, please run 
        ECHO it again but with Admin permissions. To do so right click
        ECHO this file and click "Run as administrator".
        REM Pausing execution so the user can read the message
        PAUSE
        EXIT
    )

:install
    REM Create a temporary file that and put all of the hosts
    REM file contents in it excluding existing redirects
    FINDSTR /V "159.203.120.188 s.optifine.net # INSERTED BY CLOAKS+" "%HOSTS_FILE%" > "%TEMP_HOSTS_FILE%"
    REM Add the redirect to the new file
    ECHO 159.203.120.188 s.optifine.net # INSERTED BY CLOAKS+ >> "%TEMP_HOSTS_FILE%"
    REM Replace the Hosts file with the Temp file
    COPY /b/v/y "%TEMP_HOSTS_FILE%" "%HOSTS_FILE%"
    ECHO Install has been completed
    REM Pausing execution so the user can read the message
    PAUSE
    EXIT

:uninstall
    REM Create a temporary file that and put all of the hosts
    REM file contents in it excluding existing redirects
    FINDSTR /V "159.203.120.188 s.optifine.net # INSERTED BY CLOAKS+" "%HOSTS_FILE%" > "%TEMP_HOSTS_FILE%"
    REM Replace the Hosts file with the Temp file
    COPY /b/v/y "%TEMP_HOSTS_FILE%" "%HOSTS_FILE%"
    ECHO Uninstall has been completed
    REM Pausing execution so the user can read the message
    PAUSE
    EXIT