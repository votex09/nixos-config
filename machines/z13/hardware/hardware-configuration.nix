#=====================================================================#
# HARDWARE CONFIGURATION (PRE-INSTALL PLACEHOLDER)
#=====================================================================#
#- Lets the Z13 build before NixOS is installed on it. Never boot this file:
#- ./setup.sh's "Reinstall z13" replaces it with the installer's own
#- hardware-configuration.nix, which has the real disks and LUKS lines.
{
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod"];
  boot.kernelModules = ["kvm-amd"];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
