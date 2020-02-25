{ config, pkgs, ... }:

{
  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "uk";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Tirane";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      "alter2000" = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = [
          "alter2000"
          "adbusers"
          "ansible"
          "dialout"
          "docker"
          "kubernetes"
          "libvirtd"
          "networkmanager"
          "video"
          "wheel"
        ];
        home = "/home/alter2000";
        createHome = true;
        shell = pkgs.zsh;
      };
    };
    defaultUserShell = pkgs.bash;
    extraGroups."vboxusers".members = [ "alter2000" ];
  };

  virtualisation = {
    anbox.enable = true;

    libvirtd = {
      enable = true;
      allowedBridges = [ "virbr0" "docker0" ];
    };

    docker = {
      enable = true;
      autoPrune.enable = true;
      autoPrune.flags = [ "--all" ];
    };

    virtualbox.host = {
      enable = false;
      addNetworkInterface = true;
      enableExtensionPack = true;
      # headless = true;
    };

  };

}
