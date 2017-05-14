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
  - If the script worked correctly, it should output a series of five numbers (the ids of the newly created virtual devices)
  - If it didn't, you'll have the error messages from the underlying pactl commands
- Configure manually your media source and videoconference input with `pavucontrol`
- Enjoy !

# Heads-up

Here are some of the things that are good to know, I wish I knew some before starting to do this :
- NEVER use headphones when doing sound tinkering. It can be really dangerous, in case of driver malfunctioning, or sudden high volume.
- None of this is reboot-proof. You will have to re-execute the script after every reboot.
- `pulseaudio -k` restarts your pulseaudio daemon, reloading its configuration. Be careful however, it seems that sometimes it is not enough and makes weird stuff, if you have any doubt, reboot
- Make schemas of what you want to do. Seriously.
- By default, pavucontrol may not display everything in its listings, pay attention to the filters at the bottom of the window.
- It's probably possible to make these modifications reboot-proof by specifying the configuration in pulseaudio configuration files.

Now a few explanations about the different kinds of devices involved. This is only what I have understood experimenting so far, it has no pretention to be absolutely true and flawless.
The italicized words are vocabulary that I'm either not sure of, or made up for the sake of clarity.
- By "device", I mean either an application connected to pulseaudio API, a driver interfacing a hardware component with pulseaudio, or a virtual device created inside pulseaudio. Pretty much everything that you will see in pavucontrol listings.
- A sink is an audio output. 
  - The sinks are listed in the `Output Devices` of pavucontrol.
  - A sink can receive any number of streams from various _active_ inputs.
  - The classic example of sink is speakers, or headphones.
- There are two kinds of inputs, for the sake of clarity, let's call them _active_ and _passive_ :
  - An _active_ input is obtained from a device executing some playback, that you would expect to be routed to your speakers by default.
    - _Active_ inputs appear in the `Playback` tab of pavucontrol
    - An _active_ input stream, is directly routed to a _sink_.
    - You can select the target sink in the `Playback` tab of pavucontrol
    - The stream from an _active_ input can only be routed to a single sink.
    - A music player is a good example of such device.
  - A _passive_ input is created by a device that is not likely to output to speakers, but more likely to be discarded or routed to another program.
    - _Passive_ inputs appear in the `Input Devices` tab of pavucontrol.
    - A _passive_ input in not routed anywhere by default. You have to capture it.
    - A microphone is a very good example of such device.
- A _recorder_ is a device that captures the stream of a _passive_ input.
  - _Recorders_ are listed in the `Recording` tab of pavucontrol.
  - In this same tab, you can choose the input they're recording.
  - A given recorder can only record a single _passive_ input, but multiple recorders can listen to the same _passive_ input.
  - A good example of _recorder_ is a videoconference program, that will both contain an _active_ output (for the playback), and a _recorder_ (for sending your own voice through a microphone)
- Every sink has an associated _monitor_.
  - A monitor is a _passive_ input, that mirrors the sink it is attached to.
  - A good example of use is recording you desktop to make a video tutorial. A desktop recording program will likely provide you a _recorder_, that you can either attach to you microphone (to get your voice), or to the monitor of your speakers (to record the sounds emitted by you desktop during the demo)
- A null sink is a virtual sink created with the `module-null-sink` of pulseaudio.
  - It behaves like a "real" sink, except that it discards the stream instead of outputing it to speakers (or whatever).
  - It has a monitor as well
- A _loopback device_ is a virtual device created with the `module-loopback` of pulseaudio.
  - It behaves like the combination of a _recorder_ and a _passive_ input, relaying the stream from the former to the latter.
  - Combined with _monitors_ and null sinks, it should allow you to do basically anything you want
  
  
# Resources

These are some of the resources that I found useful when tinkering :
- https://askubuntu.com/questions/257992/how-can-i-use-pulseaudio-virtual-audio-streams-to-play-music-over-skype
- https://wiki.debian.org/audio-loopback
- https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/Modules/
- https://wiki.archlinux.org/index.php/PulseAudio
- https://wiki.ubuntu.com/PulseAudio/Log


# Contributions

Pull requests are welcome, don't hesitate !
