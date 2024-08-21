#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

echo 'T2-Atomic: Overriding sway with swayfx'

rpm-ostree cliwrap install-to-root / && \
    rpm-ostree override replace --experimental \
    --from repo=copr:copr.fedorainfracloud.org:swayfx:swayfx \
    swayfx scenefx