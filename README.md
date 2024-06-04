# T2 Atomic &nbsp; [![bluebuild](https://github.com/lauretano/t2-atomic/actions/workflows/build.yml/badge.svg)](https://github.com/lauretano/t2-atomic/actions/workflows/build.yml)

This alpha-state project endeavours to enable the best possible hardware support for Fedora Silverblue on T2 Macs (aka the last generation of Macs pre Apple Silicon). At the current moment, no ISO to publish so you'll need external keyboard/mouse to do the installation and initial rebase.

## Updates
- 10 May 2024, a COSMIC variant is in testing, not for public consumption at this time. It won't work with the below instructions as SELinux has to be disabled for it to work for now. You wouldn't want to install anyway, more of a personal spin for my own internal testing.
- as of 6 May 2024, we're rapidly approaching our first Beta release. Wifi and BT should now be mostly operational including WPA3
- keyboard (touchbar via tiny-dfr), fan control (t2fanrd), and audio support are in place. There may be speaker equalizer presets that need to be brought in (such as for MacBookPro16,1).
- at this time there's only images being built for Gnome (aka Silverblue), but Plasma (aka Kinoite) will be added soon. Let us know if you have any other requests.
- the T2-enablement work here is also being added to a fork of Universal Blue's hwe repo to possibly support future Bluefin/Bazzite versions with T2 support.

## What Works, What Doesn't
For general information on the state of Linux on T2, see [t2linux wiki](https://wiki.t2linux.org/state/)
### Works
- t2 kernel (via [sharpenedblade's t2linux copr](https://copr.fedorainfracloud.org/coprs/sharpenedblade/t2linux/)
- keyboard, trackpad (via apple-bce)
- touchbar (tiny-dfr-rust)
- fan control (t2fanrd)
- wifi/bt hardware (customized for Fedora Atomic, but based on [NoaHimesaka1873's fork of asahi-installer](https://github.com/NoaHimesaka1873/asahi-installer)
- thunderbolt
- webcam (via apple-bce)
- audio, mostly. the mic doesn't work well on some models.

### Doesn't Work for now or out of the box, but should soon
- unlocking LUKS encryption using the internal keyboard, working on a fix for this
- deep sleep, if you were running the recent macOS version that broke this via a firmware update. Will be adding in a justfile command to toggle s2idle but for now [this thread on stackexchange](https://superuser.com/questions/1792252/how-do-i-disable-suspend-to-ram-and-enable-suspend-to-idle) should help.

### Doesn't work (upstream or anywhere at this time)
- Touch ID, the T2 Secure Enclave
- T2 Audio Video Encoder (used to extend display to an iPad on macOS)

## Installation

> **Warning**  
> These images should be considered of early Alpha quality, useful for a proof of concept if you have an older T2 MacBook collecting dust you'd like to run the modern Fedora Atomic Desktops on.
> Please note that you'll need an external keyboard and mouse/trackpad to perform the Silverblue/Kinoite installation prior to rebasing.

### First, select an Image Variant
All image variants are based on Universal Blue images, so they include their update tooling, justfiles, etc. When using the rebase commands, be sure to use the correct variant for your desired DE and use case.

#### Alpha state images
- t2-atomic - as close to vanilla Fedora Atomic Gnome (Silverblue) as possible.

#### Pre-Alpha, don't install unless you love rolling back ;)
- t2-atomic-plasma - as close to vanilla Fedora Atomic KDE (Kinoite) as possible.

#### Personal spins that include a bunch of packages and flatpaks no one but Kansei wants (think 3d printing slicer apps, matrix client, a bunch of browsers, some raspberry pi-related tools, some dev tools.
- t2-atomic-cosmic-kansei - COSMIC pre-alpha, atop silverblue (so it includes gnome). WARNING: must disable selinux or you will need to rollback, you won't get past the login window.
- t2-atomic-kansei - same as t2-atomic (gnome) but with my personally used apps and flatpaks

### Then, Rebase, Find Joy

#### from a vanilla Fedora Silverblue/Kinoite image:
You'll be rebasing twice, first to the unsigned image which installs the proper signing keys and policies needed for the signed image.

- First, rebase to the unsigned image, replacing [variant] with your desired image:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/lauretano/[variant]:latest
  ```
  - example, for the default Gnome desktop:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/lauretano/t2-atomic:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, replacing [variant] with your desired image:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/lauretano/[variant]:latest
  ```
  - example, for the default Gnome desktop:
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

The `latest` tag will automatically point to the latest build. At this time, Fedora 40 is latest, and when we enable a testing tag it'll be 41/rawhide. No builds for Fedora 39 or earlier are being done.

## ISO

At this point no ISO, in preliminary testing while it works to install with the t2 kernel and the system is operational on reboot, during the install the internal keyboard/trackpad/touchbar aren't operational.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/Lauretano/t2-atomic
```
