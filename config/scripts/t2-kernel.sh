#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

rpm-ostree cliwrap install-to-root / && \
    rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:sharpenedblade:t2linux kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra
    #rpm-ostree kargs --append-if-missing=intel_iommu=on --append-if-missing=iommu=pt --append-if-missing=mem_sleep_default=s2idle
