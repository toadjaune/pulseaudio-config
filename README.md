Audio :

Tout faire depuis PulseAudio

Ressources :
https://wiki.debian.org/audio-loopback
https://askubuntu.com/questions/257992/how-can-i-use-pulseaudio-virtual-audio-streams-to-play-music-over-skype
https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/Modules/

Du moment que les différentes sources et consommateurs de flux audio sont interfacés avec pulseaudio (pas trouvé de programme ne rentrant pas dans cette catégorie jusqu'à présent), tout devrait bien se passer, avec un peu de biduillage.

C'est stable et ça tolère très bien les interruptions et reprises, etc ...

Reset pulseaudio configuration by killing the daemon with `pulseaudio -k`

