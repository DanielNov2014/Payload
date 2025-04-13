Set sound = CreateObject("WMPlayer.OCX")
sound.URL = "./sound.wav"
sound.settings.volume = 100
sound.controls.play
