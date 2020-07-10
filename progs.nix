{ config, pkgs, ... }:

{
  programs = {
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    mtr.enable = true;
    adb.enable = true;
    less.enable = true;
    light.enable = true;
    dconf.enable = true;
    gpaste.enable = true;
    iotop.enable = true;
    # iftop.enable = true;
    plotinus.enable = true;
    qt5ct.enable = true;

    bash.enableCompletion = true;
    fish = {
      enable = false;
      vendor = {
        config.enable = true;
        completions.enable = true;
        functions.enable = true;
      };
    };
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      promptInit = "";
    };

    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
        enableBrowserSocket = true;
        pinentryFlavor = "gtk2";
      };
      dirmngr.enable = true;
    };

    # ssh = {
    #   agentTimeout = null;
    #   askPassword = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
    #   startAgent = true;
    # };

  };

  fonts = {
    enableDefaultFonts = true;
    enableFontDir = true;
    fonts = with pkgs; [
      fira
      iosevka
      liberation_ttf
      libre-baskerville
      noto-fonts
      overpass
      roboto
      siji
    ];

    fontconfig = {
      enable = true;
      allowBitmaps = false;
      cache32Bit = true;
      hinting.enable = true;
      # subpixel.lcdFilter = ;

      defaultFonts = {
        monospace = [ "League Mono" "Hasklig" "IBM Plex Mono" "Powerline Extra Symbols" ];
        sansSerif = [ "Overpass" "IBM Plex Sans" "Noto Sans" ];
        serif = [ "CMU Serif" "Liberation Serif" "Noto Serif" ];
      };

    };

  };
}
