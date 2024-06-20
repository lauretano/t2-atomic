#!/usr/bin/env bash
# source: https://blue-build.org/reference/modules/brew/
# put this in a justfile eventually

if [[ -d "${HOME}/cache/Homebrew/" ]]; then
  echo "Removing '$HOME/cache/Homebrew/' directory"
  rm -r "${HOME}/cache/Homebrew/"
else
  echo "'${HOME}/cache/Homebrew/' directory is already removed"
fi


if [[ -d "/var/lib/homebrew/" ]]; then
  echo "Removing '/var/lib/homebrew/' directory"
  sudo rm -rf "/var/lib/homebrew/"
else
  echo "'/var/lib/homebrew/' directory is already removed"
fi
if [[ -d "/var/cache/homebrew/" ]]; then
  echo "Removing '/var/cache/homebrew/' directory"
  sudo rm -rf "/var/cache/homebrew/"
else
  echo "'/var/cache/homebrew/' directory is already removed"
fi
## This is the main directory where brew is located
if [[ -d "/var/home/linuxbrew/" ]]; then
  echo "Removing '/home/linuxbrew/' directory"
  sudo rm -rf "/var/home/linuxbrew/"
else
  echo "'/home/linuxbrew/' directory is already removed"
fi


if [[ -f "/etc/.linuxbrew" ]]; then
  echo "Removing empty '/etc/.linuxbrew' file"
  sudo rm -f "/etc/.linuxbrew"
else
  echo "'/etc/.linuxbrew' file is already removed"
fi