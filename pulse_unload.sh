#!/bin/bash

set -e

module_file="/tmp/pulseaudio_module_list.txt"

if [ ! -f "${module_file}" ]; then
  echo "ERROR: file ${module_file} doesn't exist" >&2
  exit 1
fi

while read -r module; do
  if [[ "${module}" =~ ^[0-9]+$ ]]; then
    pacmd unload-module "${module}"
  else
    echo "ERROR: file ${module_file} is not correctly formated" >&2
    exit 1
  fi
done < "${module_file}"

rm "${module_file}"
