{ config, pkgs, ... }:

let
  lcfg = (if builtins.pathExists ./local.nix then ./local.nix else {});
  ifOn = c: p: if c then p else [];
in
{
  documentation = {
    man.enable = true;
    man.generateCaches = true;
    # nixos.enable = true;
    # doc.enable = true;
    # dev.enable = true;
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
    ++ (ifOn config.services.xserver.enable [
      chromium
      firefox
      gucharmap
      mpv
      pavucontrol
      qt5.qtwayland
      xarchiver xorg.xev xdotool xclip xsel
      gnome.nautilus
      gnome.sushi
      # xfce.thunar
      # xfce.thunar-archive-plugin
      # xfce.thunar-volman
    ])
    ++ (ifOn (config.virtualisation.libvirtd.enable && config.services.xserver.enable)
        [virt-manager])
    ++ (lcfg.extraPackages or []);
  };

  nixpkgs.config.allowUnfree = true;
}
