# T2 Atomic &nbsp; [![bluebuild](https://github.com/lauretano/t2-atomic/actions/workflows/build.yml/badge.svg)](https://github.com/lauretano/t2-atomic/actions/workflows/build.yml)
Fedora Atomic Desktops for Intel Macs with T2 chips
-------------------------------
> tl;dr?: It mostly works, skip to [installation instructions](#installation)

The T2 chip, introduced in the final generation of Intel Macs, requires linux kernel patches, community-developed utilities, daemons, kernel arguments, config files, and binary firmware for use of things like the keyboard, trackpad, touchbar, webcam, and sound. The [T2Linux](https://wiki.t2linux.org/) community has built a lot of tooling and repositories to support installing distros on T2 Macs, including Fedora Workstation. T2-Atomic is built off these efforts, brought into the Fedora Atomic Desktops (aka the immutables, silverblue, sericea, kinoite, etc) world.

>Editor's Note: Please don't buy a MacBook to use Linux on it, this project is for those of us tired of macOS, with hand-me-downs, etc. Buy a [Framework](https://frame.work), something from [System76](https://system76.com/), or for heaven's sake at least a used ThinkPad. But, if you must...

## Current State (10 September 2024)
> Warning: a 2023 Apple firmware update broke deep sleep and this is still broken.
- Current images and tags published (** denoting test images or advanced images that require some configuration): 
    - Gnome (Silverblue)
    - Plasma (Kinoite)
    - Sway (Sericea)
    - Cosmic Alpha** - based on a Silverblue, includes Gnome and Gnome apps
    - Bluefin DX - Universal Blue's Bluefin DX developer experience, for T2
    - River** - Isaac Freund's [River](https://isaacfreund.com/software/river/) dynamic tiling Wayland compositor with flexible runtime configuration, on Universal Blue "base" image
    - Swayfx** - effectively Sericea modified to use Swayfx instead of Sway.
    - Tags: latest (we may add a "stable" with fsync-ba kernel like Bluefin has available)

- **Note**: External/USB input devices are **required** for installation. The internal keyboard and trackpad will not work during installation, or during encryption password prompt on boot (the latter fixed with a simple command later). If a build ever breaks the keyboard/trackpad, the immutability of Atomic Desktops helps, just boot to an earlier image and rpm-ostree rollback.
- We install bits that aren't possible to layer later via rpm-ostree, such as the wifi/bt firmware, audio components, and kernel. 
- Post-install, Several manual steps are needed to enable some of the installed packages and configuration. Examples (detailed in the [instructions](#installation) below):
  - Deep sleep causes a crash and must be disabled with a kernel argument.
  - Encrypted disk unlock with the internal keyboard requires a command to be run once.
  - Radeon graphics-equipped models (including MacBookPro 16,1) can be used with hybrid graphics via renaming a configuration file.
  - tuned DSP audio is available for some models (including the 6-speaker array MacBook Pro 16,1). The pipewire configuration file in /etc needs to be renamed to enable it.

## What Works, What Doesn't
For general information on the state of Linux on T2, see [t2linux wiki](https://wiki.t2linux.org/state/)

### Not Working
- deep sleep. Will be adding in a justfile command to toggle s2idle but for now [this thread on stackexchange](https://superuser.com/questions/1792252/how-do-i-disable-suspend-to-ram-and-enable-suspend-to-idle) should help.
- Touch ID (or anything the T2 Secure Enclave manages)
- TPM (T2 isn't a TPM but theoretically...) / secureboot --so no LUKS autounlock via TPM possible (LUKS + window manager autologin as a workaround does)

### Works Fairly Well
- touchbar (tiny-dfr-rust)
- webcam (via apple-bce)
- audio. sound quality can be poor and the mic doesn't work well on some models.
### Works Quite Well
- kernel - we're using fsync kernel to align with [Universal Blue](https://github.com/ublue-os) images.
- keyboard, trackpad (via apple-bce)
- fan control (t2fanrd)
- wifi/bt hardware (customized for Fedora Atomic, but based on [NoaHimesaka1873's fork of asahi-installer](https://github.com/NoaHimesaka1873/asahi-installer)
- thunderbolt (video via USB-C works even with thunderbolt disabled)

## Installation
> **Warning**  
> External input devices are **required** for installation. The internal keyboard and trackpad will not work during installation, or during encryption password prompt on boot (the latter fixed with a simple command later). If a build ever breaks the keyboard/trackpad, the immutability of Atomic Desktops helps, just boot to an earlier image and rpm-ostree rollback.

### Step 0 (optional): Try Fedora Workstation

If you're curious how well your T2 Mac works on Fedora, we recommend trying the T2Linux Fedora live images (traditional, non-immutable). 

We unfortunately can't provide a live environment image at this time due to the nature of the OCI deployment.

### Step 1: Select and Download an Installer

Download the Fedora Atomic Desktop image that most closely matches the T2-Atomic image you'll rebase to. Rebasing from Gnome to Plasma, for example, results in some bugs. Peruse the list of images below and proceed to download the required ISO for install.

#### T2 Atomic Flagship Images
- t2-atomic-gnome - download [Silverblue](https://fedoraproject.org/atomic-desktops/silverblue/)
- t2-atomic-plasma - download [Kinoite](https://fedoraproject.org/atomic-desktops/kinoite/)
- t2-atomic-sway - Install [Sericea](https://fedoraproject.org/atomic-desktops/sway/)
- t2-atomic-bluefin-dx - Install [Bluefin or Bluefin-DX](https://projectbluefin.io/) and rebase.

#### T2 Atomic Test Images
install if you love rolling back when things break ;)

- t2-atomic-river - Install [Sericea](https://fedoraproject.org/atomic-desktops/sway/) before rebasing (sway will be removed)
- t2-atomic-cosmic-gnome - install [Silverblue](https://fedoraproject.org/atomic-desktops/silverblue/) before rebasing
- t2-atomic-swayfx - Install [Sericea](https://fedoraproject.org/atomic-desktops/sway/) before rebasing (sway will be replaced)

### Step 2: Install Fedora Atomic from ISO

Write the ISO to a USB using dd, [Fedora Media Writer](https://flathub.org/apps/org.fedoraproject.MediaWriter), [Ventoy](https://www.ventoy.net/en/index.html), or similar. 

Proceed to install per usual (just like a typical Fedora install). Some installers (Gnome) don't have you create a user account during install. Note that dualbooting isn't supported, to attempt it make sure you back up your data before and don't touch Apple's EFI or other partitions from the Fedora installer.

### Step 3: Rebase, and Rebase Again

> **Note:** *two* rebases are needed to get to our signed images from a vanilla Fedora Atomic image.

The following steps are to be done in the terminal app used by your desktop.

- **STEP 3A: Rebase** Rebase to an unsigned interim image. Replace [variant] with your desired image: ```rpm-ostree rebase ostree-unverified-registry:ghcr.io/lauretano/[variant]:latest```
  - example, for Gnome: ```rpm-ostree rebase ostree-unverified-registry:ghcr.io/lauretano/t2-atomic:latest```
- **STEP 3B: Reboot**

  to complete the rebase: ```systemctl reboot```
- **STEP 3C: Rebase Again:** Rebase to the signed image, replacing [variant] with your desired image: ```rpm-ostree rebase ostree-image-signed:docker://ghcr.io/lauretano/[variant]:latest```
  - example, for the default Gnome desktop: ```rpm-ostree rebase ostree-image-signed:docker://ghcr.io/lauretano/t2-atomic:latest```
- Reboot again to complete the installation ```systemctl reboot```

### Step 4: Post-Installation
* on first boot, the daemons for fan speed and touchbar should already be enabled
#### Kernel Arguments for PCIe
In a terminal, run: ```rpm-ostree kargs --append-if-missing="intel_iommu=on" --append-if-missing="iommu=pt" --append-if-missing="mem_sleep_default=s2idle"```
#### Enable keyboard for encryption unlock on boot
In a terminal, run: ```rpm-ostree initramfs enable``` and reboot when prompted to. /etc/dracut.conf.d/t2-bce.conf defines the modules it will build in to load at boot, including apple-bce for the keyboard.
<!--#### Hybrid Graphics / iGPU

* content to come

#### Disabling T2-integated Ethernet (connect/disconnect notifications)

* content to come-->

## Previous Updates
- 18 June 2024, We're now publishing Plasma images to celebrate Plasma 6.1 releasing with explicit sync support. The fix for LUKS unlock is working in testing and should be available in builds soon.
- 10 May 2024, a COSMIC variant is in testing, not for public consumption at this time. It won't work with the below instructions as SELinux has to be disabled for it to work for now. You wouldn't want to install anyway, more of a personal spin for my own internal testing.
- as of 6 May 2024, we're rapidly approaching our first Beta release. Wifi and BT should now be mostly operational including WPA3
- keyboard (touchbar via tiny-dfr), fan control (t2fanrd), and audio support are in place. There may be speaker equalizer presets that need to be brought in (such as for MacBookPro16,1).
- at this time there's only images being built for Gnome (aka Silverblue), but Plasma (aka Kinoite) will be added soon. Let us know if you have any other requests.
- the T2-enablement work here is also being added to a fork of Universal Blue's hwe repo to possibly support future Bluefin/Bazzite versions with T2 support.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/Lauretano/t2-atomic
```
