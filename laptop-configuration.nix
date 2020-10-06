{ config, lib, pkgs, ... }:

let
  lcfg = (if builtins.pathExists ./local.nix then ./local.nix else {});
  unstable = import (fetchTarball
      "channel:nixpkgs-unstable"
      # "https://github.com/nixos/nixpkgs/master"
    ) { inherit config; };
in
{
  networking = {
    hostName = lcfg.networking.hostName or "alterpad";
    dhcpcd.enable = false;
    networkmanager.enable = true;
    # useDHCP = true;

    hosts = {
      "127.0.0.1" = [ "localhost" ];
      "192.168.0.1" = [ "lanlocal" ];
    };

    # Open ports in the firewall.
    firewall = {
      allowedTCPPorts = [ 25 40 80 443 4000 ];
      allowedUDPPorts = [ 25 40 80 443 4000 ];
      allowedTCPPortRanges = [ { from = 60000; to = 65535; } ];
      allowedUDPPortRanges = [ { from = 60000; to = 65535; } ];
    };

    resolvconf = {
      extraOptions = [
        "nameserver 1.1.1.1"
        "nameserver 8.8.8.8"
        "nameserver 8.8.4.4"
      ];
    };
  };

  hardware = {
    cpu.intel.updateMicrocode = lcfg.hardware.cpu.intel.updateMicrocode or true;

    pulseaudio = lcfg.hardware.pulseaudio or {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
      extraModules = with pkgs; [ pulseaudio-modules-bt ];
    };

    trackpoint = lcfg.hardware.trackpoint or {
      emulateWheel = true;
      enable = true;
      sensitivity = 130;
      speed = 120;
    };

    opengl = {
      driSupport32Bit = true;
      driSupport = true;
      extraPackages = [ pkgs.vaapiIntel ];
      extraPackages32 = [ pkgs.pkgsi686Linux.libva ];
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluezFull;
      config.General.Enable = "Source,Sink,Media,Socket";
    };

  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave";
    powertop.enable = true;
  };

  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
      volumeStep = "3%";
    };
  };

  environment.variables.XDG_DATA_DIRS = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS";
  environment.variables.GSETTINGS_SCHEMA_DIR = "${pkgs.glib.getSchemaPath pkgs.gtk3}";

  # From https://github.com/NixOS/nixpkgs/issues/45492#issuecomment-418903252
  # Set limits for esync.
  systemd.extraConfig = "DefaultLimitNOFILE=1048576";

  security.pam.loginLimits = [{
      domain = "*";
      type = "hard";
      item = "nofile";
      value = "1048576";
  }];

  location = {
    provider = "manual";
    latitude = 35.0;
    longitude = 10.0;
  };

  services = {
    # teamviewer.enable = true;

    thinkfan = {
      enable = true;
      fan = "tp_fan /proc/acpi/ibm/fan";
      levels = ''
        (0,	0,	42)
        (1,	41,	45)
        (2,	44,	48)
        (3,	47,	51)
        (4,	50,	53)
        (5,	53,	60)
        (6,	55,	66)
        (7,	63,	32767)
      '';
      sensors = ''
        hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input
        hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon4/temp2_input
        hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon4/temp3_input
      '';
      # levels = ''
      #   (0,	0,	47)
      #   (1,	46,	51)
      #   (2,	50,	55)
      #   (3,	54,	58)
      #   (4,	57,	62)
      #   (5,	60,	66)
      #   (6,	55,66)
      #   (7,	63,	32767)
      # '';
    };

    xserver = (import ./xserver.nix { inherit pkgs; });

    redshift = {
      enable = true;
      temperature = {
        day = 6300;
        night = 4100;
      };
      extraOptions = [ "-g 0.7" ];
    };

    lorri.enable = true;
    xbanish.enable = true;
    gvfs.enable = true;
    gvfs.package = pkgs.gnome3.gvfs;

    udev.extraRules = ''
      # DualShock 4 over USB hidraw
      KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
      # DualShock 4 wireless adapter over USB hidraw
      KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ba0", MODE="0666"
      # DualShock 4 Slim over USB hidraw
      KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"
      # DualShock 4 over bluetooth hidraw
      KERNEL=="hidraw*", KERNELS=="*054C:05C4*", MODE="0666"
      # DualShock 4 Slim over bluetooth hidraw
      KERNEL=="hidraw*", KERNELS=="*054C:09CC*", MODE="0666"
    '';
  };

  # ratbag
  environment.systemPackages = [ unstable.libratbag unstable.piper ];
  services.dbus.packages = [ unstable.libratbag ];
  systemd.packages = [ unstable.libratbag ];
}
