#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

echo 'T2-Atomic: Fsync Kernel Pre-Install: Installing Fsync Kernel...'

rpm-ostree cliwrap install-to-root / && rpm-ostree override replace --experimental --freeze \
    --from repo='copr:copr.fedorainfracloud.org:sentry:kernel-fsync' kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra

echo 'T2-Atomic: Fsync Kernel Post-Install: on bare betal, kernel arguments for thunderbolt, iommu, and S2idle will be applied by a startup script.'
#these commands need to be run on the bare metal so put them in a script that runs at startup
#rpm-ostree kargs --append-if-missing=intel_iommu=on --append-if-missing=iommu=pt --append-if-missing=mem_sleep_default=s2idle
#enable initramfs regeneration via rpm-ostree, 
#rpm-ostree initramfs --enable --arg=-I --arg=/etc/dracut.conf.d/t2-bce.conf
