This repository contains notes and configuration to set up specific pulseaudio configuration

# Goal

The objectif is to stream an audio medium to a videoconference, along with the microphone, and while hearing both the audio medium and the videoconference.

TODO : add a schema here

Also see [this stackoverflow issue](https://askubuntu.com/questions/257992/how-can-i-use-pulseaudio-virtual-audio-streams-to-play-music-over-skype), which is the main base for this repository.

# Installation

it is supposed that you already have a working installation of pulseaudio, launched automatically by your non-root user (case by default under Gnome, it seems).

- Clone this repository : `git clone https://github.com/toadjaune/pulseaudio-config`
- Edit the `pulse_setup.sh` script and define MICROPHONE and SPEAKERS to the values of your own.
- Run the script : `./pulse_setup.sh`
- Configure manually your media source and videoconference input with `pavucontrol`
- Enjoy !

# Resources

These are some of the resources that I found useful when tinkering :
- https://askubuntu.com/questions/257992/how-can-i-use-pulseaudio-virtual-audio-streams-to-play-music-over-skype
- https://wiki.debian.org/audio-loopback
- https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/Modules/
- https://wiki.archlinux.org/index.php/PulseAudio
- https://wiki.ubuntu.com/PulseAudio/Log

# Heads-up

Here are some of the things that are good to know, I wish I knew some before starting to do this :
- NEVER use headphones when doing sound tinkering. It can be really dangerous, in case of driver malfunctioning, or sudden high volume.
- None of this is reboot-proof. You will have to re-execute the script after every reboot.
- `pulseaudio -k` restarts your pulseaudio daemon, reloading its configuration. Be careful however, it seems that sometimes it is not enough and makes weird stuff, if you have any doubt, reboot
- TODO : explain the different kind of devices, and their links with the pavucontrol tabs

# Contributions

Pull requests are welcome, don't hesitate !
