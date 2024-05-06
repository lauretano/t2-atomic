# T2 Atomic &nbsp; [![build-ublue](https://github.com/blue-build/template/actions/workflows/build.yml/badge.svg)](https://github.com/blue-build/template/actions/workflows/build.yml)

This alpha-state project endeavours to enable the best possible hardware support for Fedora Silverblue on T2 Macs (aka the last generation of Macs pre Apple Silicon). At the current moment, no ISO to publish so you'll need external keyboard/mouse to do the installation and initial rebase.

## Updates
- as of 6 May 2024, we're rapidly approaching our first Beta release. Wifi and BT should now be mostly operational including WPA3, thanks to @NoaHimesaka1873's fork of [asahi-installer](https://github.com/NoaHimesaka1873/asahi-installer)
- keyboard (touchbar via tiny-dfr), fan control (t2fanrd), and audio support are in place. There may be speaker equalizer presets that need to be brought in (such as for MacBookPro16,1).
- at this time there's only images being built for Gnome (aka Silverblue), but Plasma (aka Kinoite) will be added soon. Let us know if you have any other requests.
- the T2-enablement work here is also being added to a fork of Universal Blue's hwe repo to possibly support future Bluefin/Bazzite versions with T2 support.

## Installation

> **Warning**  
> These images should be considered of early Alpha quality, useful for a proof of concept if you have an older T2 MacBook collecting dust you'd like to run the modern Fedora Atomic Desktops on.

### If you're on a vanilla Fedora Silverblue image:
Rebasing from Kinoite isn't supported, you may encounter some bugs, most of which can be worked around with some effort. Luckily you can always roll back!

You'll be rebasing twice, first to the unsigned image which installs the proper signing keys and policies needed for the signed image.

- First, rebase to the unsigned image:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/lauretano/t2-atomic:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/lauretano/t2-atomic:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

### If you're already using a Universal Blue image (Bluefin, Bazzite, the unsupported -main images):
- Rebase to the signed image directly:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/lauretano/t2-atomic:latest
  ```
- Reboot when prompted
  ```
  systemctl reboot
  ```

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version. At this time, Fedora 40 is latest, and when we enable a testing tag it'll be 41/rawhide.

## ISO

If build on Fedora Atomic, you can generate an offline ISO with the instructions available [here](https://blue-build.org/learn/universal-blue/#fresh-install-from-an-iso). These ISOs cannot unfortunately be distributed on GitHub for free due to large sizes, so for public projects something else has to be used for hosting.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/Lauretano/t2-atomic
```
