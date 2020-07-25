{ config, pkgs, ... }:

let
  lcfg = (if builtins.pathExists ./local.nix then ./local.nix else {});
in
{
  environment = {

    extraOutputsToInstall = [
      "doc"
    ];
    variables = {
      PAGER = "less --ignore-case --status-column --raw-control-chars --quiet --window=-3";
      EDITOR = "vim";
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
      manpages mosh
      ntfs3g
      parallel
      ranger ripgrep rsync ruby
      stdmanpages
      tmux tree
      wget wirelesstools

      aspell aspellDicts.en aspellDicts.fr aspellDicts.de
      gvfs
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
      # xfce.thunar
      # xfce.thunar-archive-plugin
      # xfce.thunar-volman
    ] else [])
    ++ (lcfg.extraPackages or []);
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      (self: super: {
        polybar = super.polybar.override {
          githubSupport = true;
          i3Support = true;
          # i3GapsSupport = true;
          nlSupport = true;
          mpdSupport = true;
          pulseSupport = true;
      };})
    ];
  };
}
