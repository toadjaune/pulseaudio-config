#!/bin/bash

# This script sets up pulseaudio virtual devices
# The following variables must be set to the names of your own microphone and speakers devices
# You can find their names with the following commands :
# pacmd list-sources
# pacmd list-source-outputs
# Use pavucontrol to make tests for your setup and to make the runtime configuration
# Route your audio source to virtual1
# Record your sound (videoconference) from virtual2.monitor

set -e

MICROPHONE=${MICROPHONE:-"alsa_input.pci-0000_00_1b.0.analog-stereo"}
SPEAKERS=${SPEAKERS:-"alsa_output.pci-0000_00_1b.0.analog-stereo"}

module_file="/tmp/pulseaudio_module_list.txt"

if ! pacmd list-sources | grep -P "^\s+name: <${MICROPHONE}>" >/dev/null; then
  echo "ERROR: Microphone (source) \"${MICROPHONE}\" was not found" >&2
  exit 1
fi

if ! pacmd list-sinks | grep -P "^\s+name: <${SPEAKERS}>" >/dev/null; then
  echo "ERROR: Speaker (sink) \"${SPEAKERS}\" was not found" >&2
  exit 1
fi

# Create the null sinks
# virtual1 gets your audio sources (mplayer ...) that you want to hear and share
# virtual2 gets all the audio you want to share (virtual1 + micro)
pactl load-module module-null-sink sink_name=virtual1 sink_properties=device.description="virtual1" >> "${module_file}"
pactl load-module module-null-sink sink_name=virtual2 sink_properties=device.description="virtual2" >> "${module_file}"

# Now create the loopback devices, all arguments are optional and can be configured with pavucontrol
pactl load-module module-loopback source=virtual1.monitor sink="${SPEAKERS}" latency_msec=1 >> "${module_file}"
pactl load-module module-loopback source=virtual1.monitor sink=virtual2 latency_msec=1 >> "${module_file}"
pactl load-module module-loopback source="${MICROPHONE}" sink=virtual2 latency_msec=1 >> "${module_file}"

# This should not be necessary, however some programs (zoom) won't be able to see monitors
# We could manually re-assign them with pavucontrol or similar, but creating a virtual source is more convenient
pactl load-module module-virtual-source source_name=virtual2.mic master=virtual2.monitor source_properties=device.description=Virtual2Mic >> "${module_file}"

# If you struggle to find the correct values of your physical devices, you can
# also simply leave these undefined, and configure everything manually via pavucontrol
# pactl load-module module-loopback source=virtual1.monitor
# pactl load-module module-loopback source=virtual1.monitor sink=virtual2
# pactl load-module module-loopback sink=virtual2
