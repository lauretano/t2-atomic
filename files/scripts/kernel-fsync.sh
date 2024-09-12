#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail


# install the kernel RPMs that have been copied to /tmp from the ublue
#  kernel-cache containerfile
rpm-ostree cliwrap install-to-root / && \

rpm-ostree override replace --experimental \
        /tmp/kernel-rpms/kernel-[0-9]*.rpm \
        /tmp/kernel-rpms/kernel-core-*.rpm \
        /tmp/kernel-rpms/kernel-modules-*.rpm \
        /tmp/kernel-rpms/kernel-tools-[0-9]*.rpm \
        /tmp/kernel-rpms/kernel-tools-libs.rpm