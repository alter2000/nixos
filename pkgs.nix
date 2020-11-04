{ config, pkgs, ... }:

let
  lcfg = (if builtins.pathExists ./local.nix then ./local.nix else {});
in
{
  documentation = {
    man.enable = true;
    man.generateCaches = true;
    nixos.enable = true;
    doc.enable = true;
    dev.enable = true;
  };

  environment = {

    variables = {
      PAGER = "less --ignore-case --status-column --raw-control-chars --quiet --window=-3";
      EDITOR = "vi";
      GIO_EXTRA_MODULES = [ "${pkgs.gvfs}/lib/gio/modules" ];
    };

    systemPackages = with pkgs; [
      acpi
      curl
      elinks exfat
      file
      git
      htop
      iproute
      mosh
      ntfs3g
      parallel
      ranger ripgrep rsync ruby
      stdmanpages
      tmux tree
      wget wirelesstools

      aspell aspellDicts.en aspellDicts.fr aspellDicts.de
      # gvfs
      glib
      ncdu
      tig
      unzip usbutils
    ]
    ++ (if config.services.xserver.enable then [
      chromium
      firefox
      gucharmap
      mpv
      pavucontrol
      qt5.qtwayland
      xarchiver xorg.xev xdotool xclip xsel
      gnome3.nautilus
      gnome3.sushi
      # xfce.thunar
      # xfce.thunar-archive-plugin
      # xfce.thunar-volman
    ] else [])
    ++ (lcfg.extraPackages or []);
  };

  nixpkgs.config.allowUnfree = true;
}
