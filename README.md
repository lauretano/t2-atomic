# T2 Atomic
[![bluebuild](https://github.com/lauretano/t2-atomic/actions/workflows/build.yml/badge.svg)](https://github.com/lauretano/t2-atomic/actions/workflows/build.yml)

[![bluebuild](https://github.com/lauretano/t2-atomic/actions/workflows/build-test.yml/badge.svg)](https://github.com/lauretano/t2-atomic/actions/workflows/build-test.yml)

Fedora Atomic Desktops for Macs with T2 chips
-------------------------------

Gnome - Plasma - Sway - Cosmic - River

- [Installation Instructions](#installation)
- [Advanced Settings](#advanced-settings)

### Who is this for?
Please don't buy a MacBook to use Linux on it, this project is for those of us tired of macOS, with hand-me-downs, etc. Buy a [Framework](https://frame.work), something from [System76](https://system76.com/), or for the love of compute at least a used ThinkPad. But, if you must... [T2Linux](https://wiki.t2linux.org/) has built a lot of documentation,tooling, and specialty repositories to support installing distros on T2 Macs, including Fedora Workstation. T2-Atomic is built off these efforts, brought into the atomic/immutable world.

### Why Atomic/Immutable?
Your T2 Mac has specialized needs, requiring patched kernels, kernel arguments, assistance packages, daemons, etc --and that's just to use the keyboard and trackpad. Instead of worrying if the latest version of some small but critical utility will break your Mac on reboot, let our modern build and test pipeline find incompatibilities before those ever get to your device. Relax and let the daily updates stage in the background. When you reboot, you'll get new base OS software. 

Fedora Atomic brings the distro into the modern age, where the base OS and packages are updated via images published here on github, your day to day apps are largely containerized like on a smartphone OS (via flatpak), and rollbacks if an update fails are easy. Think more like updating a chromebook than updating Arch Linux.

## Current State (February 2025)

> Warning: a 2023 Apple firmware update broke deep sleep and this is still broken. See note above.
- Current images and tags published (** denoting test images or advanced images that require some configuration): 
    - Gnome (Silverblue)
    - Plasma (Kinoite)
    - Sway (Sericea)
    - Cosmic Alpha** - based on Silverblue, includes Gnome and Gnome apps
    - Bluefin and Aurora - Universal Blue's Bluefin and Aurora images, for T2
    - Bluefin-DX and Aurora-DX - Univeral Blue's Bluefin Developer Experience, for T2
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

## State of Support
For general information on the state of Linux on T2, see [t2linux wiki](https://wiki.t2linux.org/state/)

### Works, but Requires User Intervention
- wifi/bt hardware --before install, you must run the script from [t2linux wiki](https://wiki.t2linux.org/guides/wifi-bluetooth/) to generate an RPM package. See Step 0 in the Installation section.

### Works Quite Well
- kernel - we're using fsync kernel to align with [Universal Blue](https://github.com/ublue-os) images.
- keyboard, trackpad (via apple-bce)
- fan control (t2fanrd)
- thunderbolt (video via USB-C works even with thunderbolt disabled)
### Works Fairly Well
- touchbar (tiny-dfr-rust)
- webcam (via apple-bce) - in my personal experience with some instability probably associated with the audio device.
- audio. sound quality can be poor and the internal mic doesn't work well on some models (causing instability)
### Not Working
- dualbooting (due to use of anaconda installer).
- sleep/suspend --broken with an Apple firmware update most of these macs have by now.
- Touch ID (or anything the T2 Secure Enclave manages)
- TPM (T2 isn't a TPM but theoretically...) / secureboot --so no LUKS autounlock via TPM possible (LUKS + window manager autologin as a workaround does)

## Installation
> **Warning**  
> External input devices are **required** for installation. The internal keyboard, trackpad, and wifi will not work during installation. If a build ever breaks the keyboard/trackpad, the immutability of Atomic Desktops helps, you'll be able to use the keyboard during the Grub boot menu, just select an earlier image (by date) to recover.

### Step 0 (REQUIRED): from Mac OS, save your Wifi firmware. 
This is required because the Broadcom firmware is non-redistributable proprietary code. Whe

Using the script from [T2linux Wiki](https://wiki.t2linux.org/guides/wifi-bluetooth/), following their steps to run the script from Mac OS. When prompted with the question about saving the firmware to the EFI or creating a package, choose to create an RPM package. Save the resulting .rpm (it'll put it in your mac's Downloads folder) to external storage for safekeeping, you'll need it later. The current (F41) Fedora installer for atomic desktops will likely mess with slash destroy that EFI, as it doesn't support dualbooting scenarios.

### Step 1: Select and Download an Installer

Download the Fedora Atomic Desktop image that most closely matches the T2-Atomic image you'll rebase to. Rebasing from Gnome to Plasma, for example, results in some bugs. Peruse the list of images below and proceed to download the required ISO for install.

#### T2 Atomic Flagship Images
- t2-atomic-gnome - download [Silverblue](https://fedoraproject.org/atomic-desktops/silverblue/)
- t2-atomic-plasma - download [Kinoite](https://fedoraproject.org/atomic-desktops/kinoite/)
- t2-atomic-sway - Install [Sericea](https://fedoraproject.org/atomic-desktops/sway/)

#### T2 Atomic Test Images
install if you love rolling back when things break ;). Likely the login window is broken.
- t2-atomic-river - Install [Sericea](https://fedoraproject.org/atomic-desktops/sway/) before rebasing (sway will be removed)
- t2-atomic-cosmic-gnome - install [Silverblue](https://fedoraproject.org/atomic-desktops/silverblue/) before rebasing


### Step 2: Install Fedora Atomic from ISO

Write the ISO to a USB using dd, [Fedora Media Writer](https://flathub.org/apps/org.fedoraproject.MediaWriter), [Ventoy](https://www.ventoy.net/en/index.html), or similar. 

Proceed to install per usual (just like a typical Fedora install). Some installers (Gnome) don't have you create a user account during install. Note that dualbooting isn't supported, to attempt it make sure you back up your data before and don't touch Apple's EFI or other partitions from the Fedora installer.

### Step 3: First boot

On first boot, your wifi and bluetooth won't be working. Copy the RPM you generated from Mac OS to your Fedora install and then from a terminal run "rpm-ostree install [rpm path]". Then reboot.

### Step 4: Rebase to T2-Atomic
> **Note:** *two* rebases are needed to get to our signed images from a vanilla Fedora Atomic image.

- **STEP 4A: Rebase** Rebase to an unsigned interim image. Replace [variant] with your desired image: ```rpm-ostree rebase ostree-unverified-registry:ghcr.io/lauretano/[variant]:latest```
  - example, for Gnome: ```rpm-ostree rebase ostree-unverified-registry:ghcr.io/lauretano/t2-atomic:latest```
- **STEP 4B: Reboot**

  to complete the rebase: ```systemctl reboot```
- **STEP 4C: Rebase Again:** Rebase to the signed image, replacing [variant] with your desired image: ```rpm-ostree rebase ostree-image-signed:docker://ghcr.io/lauretano/[variant]:latest```
  - example, for the default Gnome desktop: ```rpm-ostree rebase ostree-image-signed:docker://ghcr.io/lauretano/t2-atomic:latest```
- Reboot again to complete the installation ```systemctl reboot```

### Step 5: Post-Installation
#### Kernel Arguments for PCIe/Thunderbolt support
In a terminal, run: ```rpm-ostree kargs --append-if-missing="intel_iommu=on" --append-if-missing="iommu=pt" --append-if-missing="mem_sleep_default=s2idle"```

## Advanced Settings
#### Hybrid Graphics / iGPU
In Linux, you can enable the iGPU and the dGPU will operate in a low power state by default, allowing you to specify or limit which apps are allowed dGPU access to save power/heat/battery. By default, the iGPU is disabled and the dGPU operates in the same automatic state. See [Hybrid Graphics(T2Linux Wiki)](https://wiki.t2linux.org/guides/hybrid-graphics/) for more information.

To enable the Intel integrated graphics, edit the file ```/etc/modprobe.d/apple-gmux.conf``` (creating it if not present). We provide the file with the option commented out. Uncomment, save and reboot to continue. An exmaple of the file enabling the iGPU is as follows:
```
# /etc/modprobe.d/apple-gmux.conf
#
# Enable the iGPU by setting force_igd=y
# Disable it by commenting out the line or setting force_igd=n
options apple-gmux force_igd=y
```
#### Disabling T2-integated Ethernet (connect/disconnect notifications)

Edit or create /etc/modprobe.d/t2-eth-blocklist.conf

```
# T2 Atomic
# disable the T2 chip internal USB ethernet, as the downstream devices
# aren't yet supported (Touch ID, etc)
blacklist cdc_ncm
blacklist cdc_mbim
```
Save and restart

## Troubleshooting
### Rolling Back
Something go wrong with a new build? Follow these steps.
- Reboot, and from the boot menu select the previous deployment (you may need to press space or some other keyboard key to present the menu)
- When the previous deployment boots, run ```rpm-ostree rollback```, which will make the older deployment the active one.
- If you think this failure was caused by our image please open an issue here on github, we'll be happy to investigate.

## Major Updates
- 3 February 2025 New Installation steps around generating an RPM of your WiFi firmware from Mac OS before install.
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
