@ECHO OFF
setlocal EnableDelayedExpansion

:: Auto elevation code taken from the following answer-
:: https://stackoverflow.com/a/28467343/14312937

:: net file to test privileges, 1>NUL redirects output, 2>NUL redirects errors
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto START ) else ( goto getPrivileges ) 

:getPrivileges
if '%1'=='ELEV' ( goto START )

set "batchPath=%~f0"
set "batchArgs=ELEV"

:: Add quotes to the batch path, if needed
set "script=%0"
set script=%script:"=%
IF '%0'=='!script!' ( GOTO PathQuotesDone )
    set "batchPath=""%batchPath%"""
:PathQuotesDone

:: Add quotes to the arguments, if needed
:ArgLoop
IF '%1'=='' ( GOTO EndArgLoop ) else ( GOTO AddArg )
    :AddArg
    set "arg=%1"
    set arg=%arg:"=%
    IF '%1'=='!arg!' ( GOTO NoQuotes )
        set "batchArgs=%batchArgs% "%1""
        GOTO QuotesDone
        :NoQuotes
        set "batchArgs=%batchArgs% %1"
    :QuotesDone
    shift
    GOTO ArgLoop
:EndArgLoop

:: Create and run the vb script to elevate the batch file
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "cmd", "/c ""!batchPath! !batchArgs!""", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%temp%\OEgetPrivileges.vbs" 
exit /B

:START
:: Remove the elevation tag and set the correct working directory
IF '%1'=='ELEV' ( shift /1 )
cd /d %~dp0

:: Main script here

@echo off
set "_folder=%programdata%\U3BvdHRlcg"
set "_smprograms=%programdata%\Microsoft\Windows\Start Menu\Programs"

if not exist "%_folder%\create_shortcuts.vbs" (
    (
        echo:Set oWS = WScript.CreateObject^("WScript.Shell"^)
        echo:Set oSpotter = oWS.CreateShortcut^("%_folder%\SpotX.lnk"^)
        echo:
        echo:oSpotter.TargetPath = "%_folder%\spotter.bat"
        echo:oSpotter.IconLocation = "%_folder%\spotter.ico" & ",0"
        echo:
        echo:oSpotter.Save
    ) > "%_folder%\create_shortcuts.vbs"
)
cscript //nologo "%_folder%\create_shortcuts.vbs"
copy "%_folder%\SpotX.lnk" "%_smprograms%\SpotX.lnk" /y