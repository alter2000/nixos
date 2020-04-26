{ pkgs }:

{
  enable = true;
  layout = "gb";
  xkbOptions = "caps:ctrl_modifier";
  autoRepeatDelay = 220;
  autoRepeatInterval = 34;

  libinput = {
    enable = true;
    scrollMethod = "twofinger";
    horizontalScrolling = true;
    scrollButton = 1;
    additionalOptions = ''
      Option "TappingDrag" "true"
    '';
  };

  desktopManager.xterm.enable = false;
  displayManager = {
    defaultSession = "none+i3";
    sessionCommands = "exec ~/.xsession";

    session = [ {
      name = "i3";
      manage = "desktop";
      start = ''
        exec ~/.xsession
      '';
    } ];

    lightdm = {
      enable = true;
      autoLogin.enable = false;
      autoLogin.user = "alter2000";
      greeters.mini = {
        enable = true;
        user = "alter2000";
        extraConfig = ''
          [greeter]
          password-label-text = open me up daddy

          [greeter-theme]
          background-image = ""
          font = Iosevka
        '';
      };
    };
  };

  windowManager = {
    # sway = {
    #   enable = true;
    #   package = pkgs.sway;
    #   extraPackages = with pkgs; [rofi waybar swaylock];
    # };

    i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [ rofi polybar i3lock-color ];
    };

    xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: with hp; [
        xmonad-contrib
        monad-logger
      ];
    };

  };

}
