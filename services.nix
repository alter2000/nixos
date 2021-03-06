{ config, pkgs, ... }:

let
  lcfg = (if builtins.pathExists ./local.nix then ./local.nix else {});
in

{
  xdg.portal = {
    enable = true;
    gtkUsePortal = false;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  services = {
    fstrim.enable = true;
    ntp.enable = true;
    tlp.enable = true;
    flatpak.enable = true;

    acpid.enable = true;
    fprintd.enable = lcfg.services.fprintd.enable or true;
    gpm.enable = true;

    dbus.socketActivated = true;
    dbus.packages = with pkgs; [ gnome3.dconf ];

    locate.enable = true;
    locate.interval = "30min";

    logind.lidSwitch = "suspend";
    logind.lidSwitchDocked = "ignore";

    offlineimap.enable = true;
    offlineimap.path = [pkgs.bash pkgs.pass pkgs.python];

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
}
