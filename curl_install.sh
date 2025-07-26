#!/bin/bash
#Steam Deck Additional NVME Mount - Minimal Version
#License: DBAD: https://github.com/bcomnes/Steam-Deck.Mount-External-Drive/blob/main/LICENSE.md
#Source: https://github.com/bcomnes/Steam-Deck.Mount-External-Drive
# Use at own Risk!

#curl -sSL https://raw.githubusercontent.com/bcomnes/Steam-Deck.Mount-External-Drive/minimal/curl_install.sh | bash

#stop running script if anything returns an error (non-zero exit )
set -e

repo_url="https://raw.githubusercontent.com/bcomnes/Steam-Deck.Mount-External-Drive/minimal"
repo_lib_dir="$repo_url/lib"

tmp_dir="/tmp/scawp.SDMED.minimal.install"

rules_install_dir="/etc/udev/rules.d"

device_name="$(uname --nodename)"
user="$(id -u deck)"

if [ "$device_name" != "steamdeck" ] || [ "$user" != "1000" ]; then
  zenity --question --width=400 \
  --text="This code has been written specifically for the Steam Deck with user Deck \
  \nIt appears you are running on a different system/non-standard configuration. \
  \nAre you sure you want to continue?"
  if [ "$?" != 0 ]; then
    echo "bye then! xxx"
    exit 1;
  fi
fi

function install_minimal_nvme_support () {
  zenity --question --width=400 \
    --text="This will add minimal support for additional NVME drives (nvme1n1+) with exFAT. \
  \nThis works alongside Valve's existing automount system. \
  \nDo you want to install the Additional NVME Support?"
  if [ "$?" != 0 ]; then
    echo "bye then! xxx"
    exit 0;
  fi

  echo "Making tmp folder $tmp_dir"
  mkdir -p "$tmp_dir"

  echo "Downloading Additional NVME Rules"
  curl -o "$tmp_dir/100-additional-nvme-automount.rules" "$repo_lib_dir/100-additional-nvme-automount.rules"

  echo "Copying $tmp_dir/100-additional-nvme-automount.rules to $rules_install_dir/100-additional-nvme-automount.rules"
  sudo cp "$tmp_dir/100-additional-nvme-automount.rules" "$rules_install_dir/100-additional-nvme-automount.rules"

  echo "Reloading udev rules"
  sudo udevadm control --reload

  echo "Cleaning up temp files"
  rm -rf "$tmp_dir"
}

install_minimal_nvme_support

zenity --info --width=400 \
  --text="Installation complete! \
\nAdditional NVME drives (nvme1n1, nvme2n1, etc.) with exFAT will now automount. \
\nNo restart required - plug in your drive to test."

echo "Done."
