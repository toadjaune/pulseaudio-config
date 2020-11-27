#!/bin/bash

set -e

usage() {
  echo "Usage: $0 [<file with modules to unload>]" >&2
  exit 1
}

if [ $# -gt 1 ]; then
  usage
fi

module_file=${1:-"module_list.txt"}

if [ ! -f "${module_file}" ]; then
  echo "ERROR: file ${module_file} doesn't exist" >&2
  usage
fi

while read -r module; do
  pacmd unload-module "${module}"
done < "${module_file}"

rm "${module_file}"
