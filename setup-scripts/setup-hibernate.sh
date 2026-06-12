#!/bin/bash
set -euo pipefail

# 1. Find the real swap partition (excludes zram)
SWAP_DEV=$(swapon --show=NAME,TYPE --noheadings | awk '$2=="partition" && $1 !~ /zram/ {print $1; exit}')
[ -n "$SWAP_DEV" ] || { echo "No swap partition found"; exit 1; }
UUID=$(blkid -s UUID -o value "$SWAP_DEV")
echo "Using swap: $SWAP_DEV (UUID=$UUID)"

# 2. Add resume hook (not needed with systemd initramfs)
sudo cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bak
if grep -E '^HOOKS=' /etc/mkinitcpio.conf | grep -qw systemd; then
    echo "systemd initramfs - no resume hook needed"
elif ! grep -E '^HOOKS=' /etc/mkinitcpio.conf | grep -qw resume; then
    sudo sed -i '/^HOOKS=/s/filesystems/filesystems resume/' /etc/mkinitcpio.conf
    echo "Added resume hook"
fi

# 3. Add resume= to the embedded UKI cmdline
CMDLINE=/etc/kernel/cmdline
sudo touch "$CMDLINE"
sudo cp "$CMDLINE" "$CMDLINE.bak"
if ! grep -q "resume=UUID=$UUID" "$CMDLINE"; then
    sudo sed -i "\$s/\$/ resume=UUID=$UUID/" "$CMDLINE"
fi
echo "cmdline now: $(cat $CMDLINE)"

# 4. Rebuild the UKI
sudo mkinitcpio -P

echo "Done. Reboot, then test with: systemctl hibernate"
