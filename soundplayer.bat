@echo off
:: Check for admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:: Get script directory without trailing backslash
SET mypath=%~dp0
SET mypath=%mypath:~0,-1%

:: Navigate to script directory
cd /d "%mypath%"

:: Download file using curl
curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/daisy-daisy.wav

:: Verify download success
if not exist "%mypath%\daisy-daisy.wav" (
    echo Failed to download the file!
    pause
    exit
)


:: Play sound using PowerShell
powershell -c (New-Object Media.SoundPlayer "daisy-daisy.wav").PlaySync();
