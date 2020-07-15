{ config, lib, pkgs, ... }:
let
  cfg = config.alter.autoMount;
in
# TODO: inherit (lib) usedThings;
# with lib;
{
  # TODO: not this
  # imports = [ <home-manager/nixos> ];

  options = {
    hazel.autoMount = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = ''
          Enable automatic mounting of devices.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.gvfs.enable = true;
    services.udisks2.enable = true;
    services.devmon.enable = true;

    hazel.home = {
      services.udiskie = {
        enable = true;
        tray = "never";
      };

      # home.packages = with pkgs; [ udiskie ];
    };
  };
}
