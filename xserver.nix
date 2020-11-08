{ pkgs }:

let
  i3pkgs = with pkgs; [
    rofi
    # polybar
    i3lock-color
  ];

  swaypkgs = with pkgs; [
    wofi
    waybar
    swaylock
  ];

  xmonadpkgs = pkgs: with pkgs; [
    xmonad-contrib
    xmonad-extras
    monad-logger
  ];

  isWayland = false;
in
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
    defaultSession = "xsession";

    session = [ {
      name = "xsession";
      manage = "desktop";
      start = ''
        exec ~/.xsession
      '';
    } ];

    autoLogin.enable = false;
    autoLogin.user = "alter2000";

    lightdm.enable = true;
    lightdm.greeters.mini = {
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

  windowManager = {
    i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = i3pkgs;
    };

    xmonad = {
      enable = false;
      enableContribAndExtras = true;
      extraPackages = xmonadpkgs;
      haskellPackages = pkgs.haskell.packages.ghc883;
    };
  };

  xautolock = let
    locker = /home/alter2000/.dots/bin/lock.sh;
    in {
      # int -> minutes
      enable = false;
      time = 10;
      inherit locker;
      killtime = 0;
      killer = locker;
      enableNotifier = true;
      notify = 10;
      notifier = "${pkgs.libnotify}/bin/notify-send --urgency=critical \"Locking in 10 seconds\"";
    };

}
