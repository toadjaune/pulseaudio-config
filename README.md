Audio :

Tout faire depuis PulseAudio

Ressources :
https://wiki.debian.org/audio-loopback
https://askubuntu.com/questions/257992/how-can-i-use-pulseaudio-virtual-audio-streams-to-play-music-over-skype
https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/Modules/

Du moment que les différentes sources et consommateurs de flux audio sont interfacés avec pulseaudio (pas trouvé de programme ne rentrant pas dans cette catégorie jusqu'à présent), tout devrait bien se passer, avec un peu de biduillage.

C'est stable et ça tolère très bien les interruptions et reprises, etc ...

Reset pulseaudio configuration by killing the daemon with `pulseaudio -k`

# virtual1 gets mplayer only
# virtual2 gets virtual1 + micro
pactl load-module module-null-sink sink_name=virtual1 sink_properties=device.description="virtual1"
pactl load-module module-null-sink sink_name=virtual2 sink_properties=device.description="virtual2"

# Now create the loopback devices, all arguments are optional and can be convifured with pavucontrol
# Then use `pacmd list-sources` to find the correct values
pactl load-module module-loopback source=virtual1.monitor sink=alsa_output.pci-0000_00_1b.0.analog-stereo
pactl load-module module-loopback source=virtual1.monitor sink=virtual2
pactl load-module module-loopback source=alsa_input.pci-0000_00_1b.0.analog-stereo sink=virtual2



Vidéo :

Plus tricky

Pour pouvoir accéder au flux vidéo comme une webcam, il faut qu'il sorte d'un device v4l2.

Le dépôt suivant permet d'en créer un virtuel, avec lui-même comme entrée (loopback, quoi) :
https://github.com/umlaeute/v4l2loopback
(Ne pas oublier d'installer les Headers du kernel pour pouvoir compiler ce module, `dnf install kernel-devel` pour Fedora)

compiler aussi les programmes d'exemple (juste make dans le dossier)

Pour lancer la vidéo :

modprobe v4l2loopback
mkfifo /tmp/pipe
./yuv4mpeg_to_v4l2 /dev/video1 < /tmp/pipe
mplayer file.mkv -vo yuv4mpeg:file=/tmp/pipe
