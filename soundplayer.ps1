 Add-Type -AssemblyName presentationCore
 $mediaPlayer = New-Object system.windows.media.mediaplayer
 $mediaPlayer.open('\daisy-daisy.wav')
 $mediaPlayer.Play()
