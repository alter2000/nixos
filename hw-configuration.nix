{ config, lib, pkgs, ... }:

let
  lcfg = (if builtins.pathExists ./local.nix then ./local.nix else {});
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    (if (lcfg.server or false) then
        ./server-configuration.nix
      else
        ./laptop-configuration.nix)
  ];

  # https://discourse.nixos.org/t/runtime-alternative-to-patchelf-set-interpreter/3539/5
  system.activationScripts.ldso = lib.stringAfter [ "usrbinenv" ] ''
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2 # atomically replace
  '';

  fileSystems = lib.mkDefault {
    "/" = {
      device = "/dev/disk/by-label/lunix";
      fsType = "btrfs";
      options = ["discard" "relatime" "subvol=@nixos" "compress=lzo" "space_cache"];
    };
    "/boot" = {
      device = "/dev/disk/by-partlabel/esp";
      fsType = "vfat";
    };
    "/home" = {
      device = "/dev/disk/by-label/lunix";
      fsType = "btrfs";
      options = ["discard" "relatime" "subvol=@home" "compress=lzo" "space_cache"];
    };
  };

  swapDevices = lib.mkDefault [ {
    device = "/dev/disk/by-partlabel/Swap";
  } ];

  boot = lib.mkDefault {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      checkJournalingFS = true;
      supportedFilesystems = [
        "btrfs"
        "vfat"
        "ext4"
        "exfat"
      ];
      availableKernelModules = [
        "btrfs"
        "crc32c_intel"
        "nvme"
        "rfkill"
        "scsi_mod"
        "sd_mod"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];
    };

    # plymouth = {
    #   enable = true;
    #   theme = "breeze";
    # };

    loader = {
      grub.enable = false;
      systemd-boot.enable = true;
      # systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
      timeout = 2;
    };
    tmpOnTmpfs = true;
    # earlyVconsoleSetup = true;
  };

  nix = {
    maxJobs = lib.mkDefault 3;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };
}
