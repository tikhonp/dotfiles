#!/bin/bash

# For uefi boot UKI directly disable secure boot and boot order lock:
# Reboot -> F1 -> Startup -> Boot Order Lock -> Disable
# Reboot -> F1 -> Security -> Secure Boot -> Disable ?
#
#  sudo efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "arch-linux" --loader '\EFI\Linux\arch-linux.efi' --unicode
#  sudo efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "arch-linux-lts" --loader '\EFI\Linux\arch-linux-lts.efi' --unicode

# Partitioning:
#
# Device            Start        End   Sectors   Size Type
# /dev/nvme0n1p1     2048    2099199   2097152     1G EFI System
# /dev/nvme0n1p2  2099200   69208063  67108864    32G Linux swap
# /dev/nvme0n1p3 69208064 1000214527 931006464 443.9G Linux root (x86-64)

# setup after chroot:
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tikhonp/dotfiles/refs/heads/main/setup-scripts/setup-after-chroot.sh)"

# 86 is ID of OPPO DAC in sinks:
#  86. OPPO HA-1 USB AUDIO 2.0 DAC Analog Stereo [vol: 0.40]
#  wpctl status
#
# wpctl set-volume 86 1.0
