#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

echo 'T2-Atomic: Kernel Pre-Install: Installing Kernel...'

rpm-ostree override replace --from repo=copr:copr.fedorainfracloud.org:sharpenedblade:t2linux \
    kernel kernel-core \
    kernel-modules kernel-modules-core

echo 'T2-Atomic: Kernel Post-Install: on bare betal, kernel arguments for thunderbolt, iommu, and S2idle will be applied by a startup script.'
#these commands need to be run on the bare metal so put them in a script that runs at startup
#rpm-ostree kargs --append-if-missing=intel_iommu=on --append-if-missing=iommu=pt --append-if-missing=mem_sleep_default=s2idle
#enable initramfs regeneration via rpm-ostree,
#rpm-ostree initramfs --enable --arg=-I --arg=/etc/dracut.conf.d/t2-bce.conf
