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

# Kinds of PulseAudio devices
Now a few explanations about the different kinds of devices involved. This is only what I have understood experimenting so far, it has no pretention to be absolutely true and flawless.
The italicized words are vocabulary that I'm either not sure of, or made up for the sake of clarity.
- By "device", I mean either an application connected to pulseaudio API, a driver interfacing a hardware component with pulseaudio, or a virtual device created inside pulseaudio. Pretty much everything that you will see in pavucontrol listings.
- A sink is an audio output. 
  - The sinks are listed in the `Output Devices` of pavucontrol.
  - A sink can receive any number of streams from various _players_. In this case, these inputs are superposed.
  - The classic example of sink is speakers, or headphones.
- A _player_ is obtained from a device executing some playback, that you would expect to be routed to your speakers by default.
  - _Players_ appear in the `Playback` tab of pavucontrol
  - The stream coming from a _player_ is directly routed to a _sink_.
  - You can select the target sink in the `Playback` tab of pavucontrol
  - The stream from a _player_ can only be routed to a single sink.
  - A music player is a good example of such device.
- An _input_ is created by a device that is not likely to output to speakers, but more likely to be discarded or routed to another program.
  - _Inputs_ appear in the `Input Devices` tab of pavucontrol.
  - The stream from an _input_ in not routed anywhere by default. You have to capture it.
  - A microphone is a very good example of such device.
- A _recorder_ is a device that captures the stream of a _passive_ input.
  - _Recorders_ are listed in the `Recording` tab of pavucontrol.
  - In this same tab, you can choose the input they're recording.
  - A given recorder can only record a single _input_, but multiple recorders can listen to the same _input_.
  - A good example of _recorder_ is a videoconference program, that will both contain a _player_ (for the playback), and a _recorder_ (for sending your own voice through a microphone).
- Every sink has an associated _monitor_.
  - A _monitor_ is an _input_, that mirrors the sink it is attached to.
  - A good example of use is recording you desktop to make a video tutorial. A desktop recording program will likely provide you a _recorder_, that you can either attach to you microphone (to get your voice), or to the _monitor_ of your speakers (to record the sounds emitted by you desktop during the demo)
- A null sink is a virtual sink created with the `module-null-sink` of pulseaudio.
  - It behaves like a "real" sink, except that it discards the stream instead of outputing it to speakers (or whatever).
  - It has a _monitor_ as well
- A _loopback device_ is a virtual device created with the `module-loopback` of pulseaudio.
  - It behaves like the combination of a _recorder_ and an _input_, relaying the stream from the former to the latter.
  - Combined with _monitors_ and null sinks, it should allow you to do basically anything you want.

# Schemas
As told above, whenever you're trying to do anything implying virtual devices, _make a schema_ !
I seriously doubt that I would have reached my objective without drawing what I wanted.

## My convention
For such a situation, I'm convinced that it is essential to pick a convention that prevents you from drawing anything impossible.
Here is mine, and the explanations to understand the associated logic :
(TODO: Add the symbols)
- We can notice that streams can be separated in two categories, depending on where they come from and go :
  - Come from a _player_, and go to an _output_ (now referred as _active_ stream)
  - Come from an _input_, and go to a _recorder_ (now referred as _passive_ stream)
- Each block receives stream(s) on the left, and sends stream(s) on the right
- Since every sink always has an attached monitor, they are represented together in a single symbol
- If the expected stream(s) on a side are _active_, the line of this side is doubled
- Number of streams :
  - A tringular extremity does not allow any stream
  - A trapeze-shaped extremity (cut corners) allows exactly one stream
  - A flat extremity allows any number of streams (including 0)
- Virtual devices are hatched

## My setup
With this convention, my setup corresponds to the following schema :
(TODO : Add the schema)

## How to build your setup
Here are the steps I would recommend to follow to build your setup :
- Choose your chema convention (if you don't like mine, you can use colors, other shapes, etc ...)
- Add all the non-virtual devices that are relevant to your problem (everything that sends or receives streams from pulseaudio)
- Make a simple schema to represent what you want to do, without considering constraints of types and number of streams.
- Redo it, but respecting these constraints
- Try to setup it manually
  - Create the virtual devices you need (see the script in this repo to see syntax), but without specifying sources, sinks, etc
  - Route everything according to your schema in pavucontrol
- Once it works, automate it by specifying everything at device creation time in a script

# Resources

These are some of the resources that I found useful when tinkering :
- https://askubuntu.com/questions/257992/how-can-i-use-pulseaudio-virtual-audio-streams-to-play-music-over-skype
- https://wiki.debian.org/audio-loopback
- https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/Modules/
- https://wiki.archlinux.org/index.php/PulseAudio
- https://wiki.ubuntu.com/PulseAudio/Log


# Contributions

Pull requests are welcome, don't hesitate !
