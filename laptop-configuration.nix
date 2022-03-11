{ config, lib, pkgs, ... }:

let
  lcfg = (if builtins.pathExists ./local.nix then ./local.nix else {});
in
{
  imports = [ # /home/alter2000/git/me/kmonad/nix/nixos-module.nix
  ./actkbd-config.nix
  ];
  # services.kmonad.enable = true;
  # services.kmonad.configfiles = [ /home/alter2000/git/me/kmonad/mine.kbd ];

  networking = {
    hostName = lcfg.networking.hostName or "alterpad";
    dhcpcd.enable = false;
    networkmanager.enable = true;

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
    cpu.amd.updateMicrocode = true;
    pulseaudio = lcfg.hardware.pulseaudio or {
      enable = true;
      package = pkgs.pulseaudioFull;
      extraModules = with pkgs; [ pulseaudio-modules-bt pulseaudio-dlna ];
    };

    trackpoint = lcfg.hardware.trackpoint or {
      enable = true;
      emulateWheel = true;
      sensitivity = 130;
      speed = 120;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        mesa
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libvdpau-va-gl vaapiVdpau driversi686Linux.amdvlk ];
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluezFull;
      disabledPlugins = [ "sap" ];
      # settings.General.Enable = "Source,Sink,Media,Socket";
    };

  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave";
    powertop.enable = true;
  };

  sound.enable = true;

  nix.package = pkgs.nixUnstable;

  # environment.variables.XDG_DATA_DIRS = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS";
  # environment.variables.GSETTINGS_SCHEMA_DIR = "${pkgs.glib.getSchemaPath pkgs.gtk3}";

  programs.steam.enable = true;

  location = {
    provider = "manual";
    latitude = 35.0;
    longitude = 15.0;
  };

  services = {
    # teamviewer.enable = true;
    ratbagd.enable = true;
    # blueman.enable = true;

    thinkfan = {
      enable = true;
      fans = [ { type = "tpacpi"; query = "/proc/acpi/ibm/fan"; }];
      levels = [
        [0	0	42]
        [1	41	45]
        [2	44	48]
        [3	47	51]
        [4	50	53]
        [5	53	60]
        [6	55	66]
        ["level full-speed"	63	32767]
        # ["level auto"	80	32767]
      ];

      sensors = [
        { type = "hwmon"; query = "/sys/devices/platform/coretemp.0/hwmon/"; indices = [1 2 3]; }
      ];
    };

    xserver = import ./xserver.nix { inherit pkgs; };

    redshift = {
      enable = true;
      temperature.day = 6300;
      temperature.night = 4300;
      extraOptions = [ "-g 0.8" ];
    };

    lorri.enable = true;
    xbanish.enable = true;
    gvfs.enable = true;
    gvfs.package = pkgs.gnome.gvfs;

    udev.initrdRules = ''
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

}
