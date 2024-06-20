#!/usr/bin/env bash
# 2024 kansei os@cdl.sh
# simple script to load the modules required to use your keyboard for LUKS unlock on T2 Atomic

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail


echo 'T2-Atomic: Kernel Modules: Load apple-bce Early, regenerate initramfs'

# we need to set rpm-ostree to regenerate initramfs (believe this is needed every rpm-ostree upgrade), 
#  but building the image on github actions? hmm

rpm-ostree initramfs --enable --arg=-I --arg=/etc/dracut.conf.d/t2-bce.conf
