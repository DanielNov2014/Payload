echo Dim speech >> talk.vbs
echo Set speech = CreateObject("SAPI.SpVoice") >> talk.vbs
echo speech.Speak "Hello, again user this will run every time you start your computer" >> talk.vbs

start talk.vbs
timeout 3 > nul
del /f /q "talk.vbs"
