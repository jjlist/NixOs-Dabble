#!bin/sh -eux
echo =================
lsblk
echo =================
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MB 513MB
parted /dev/sda -- set 1 esp on
parted /dev/sda -- mkpart root ext4 513MB 100% #-8GB
#parted /dev/sda -- mkpart swap linux-swap -8GB 100%
lsblk
echo =================
mkfs.ext4 -L nixos /dev/sda2
mount /dev/disk/by-label/nixos /mnt
#mkswap -L swap /dev/sda2
#swapon /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda1
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
lsblk
echo =================
#
nixos-generate-config --root /mnt
read -p "Disks partition succesfully, press any key to edit configuration.nix..."
vim /mnt/etc/nixos/configuration.nix
# nixos-install
