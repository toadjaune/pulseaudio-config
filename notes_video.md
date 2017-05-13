

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
