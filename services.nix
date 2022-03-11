{ config, pkgs, ... }:

let
  lcfg = (if builtins.pathExists ./local.nix then ./local.nix else {});
in

{
  xdg.portal = {
    enable = true;
    gtkUsePortal = false;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
  };

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
    # ntp.enable = true;
    flatpak.enable = true;
    pipewire.enable = true;
    udev.packages = [ pkgs.platformio ];

    acpid.enable = true;
    fprintd.enable = lcfg.services.fprintd.enable or true;
    gpm.enable = true;

    dbus.packages = with pkgs; [ gnome.dconf ];

    locate.enable = true;
    locate.interval = "30min";

    logind.lidSwitch = "suspend";
    logind.lidSwitchDocked = "ignore";

    offlineimap.enable = true;
    offlineimap.path = [pkgs.bash pkgs.pass pkgs.python];

    tlp.enable = true;
    tlp.settings = {
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_PHONE = 1;
      USB_EXCLUDE_BTUSB = 1;
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
      WOL_DISABLE = "N";
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "wwan"; # wwan
    };

    openssh = {
      enable = false;
      startWhenNeeded = true;
      allowSFTP = true;
      ports = [40];
      gatewayPorts = "yes";
    };

    tor = {
      # enable = true;
      enableGeoIP = false;
    };

  };

  systemd.services.thinkfan.preStart = "
    /run/current-system/sw/bin/modprobe  -r thinkpad_acpi && /run/current-system/sw/bin/modprobe thinkpad_acpi
  ";
}
