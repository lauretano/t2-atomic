#!/usr/bin/env bash
set -oue pipefail

# This script disables the T2 chip internal usb ethernet,
# to prevent recurrent notifications from Network Manager about the interface.
# in the future this may need to be removed to add support for touchid etc.

printf "# Disable for now T2 chip internal usb ethernet\nblacklist cdc_ncm\nblacklist cdc_mbim" >> /etc/modprobe.d/blacklist.conf
