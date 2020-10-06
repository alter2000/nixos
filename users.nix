{ config, pkgs, ... }:

{
  console.font = "Lat2-Terminus16";
  console.keyMap = "uk";

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Tirane";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users."alter2000" = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [
        "alter2000"
        "adbusers"
        "ansible"
        "camera"
        "dialout"
        "docker"
        "kubernetes"
        "libvirtd"
        "lxd"
        "networkmanager"
        "video"
        "wheel"
      ];
      home = "/home/alter2000";
      createHome = true;
      shell = pkgs.zsh;
    };
    defaultUserShell = pkgs.bash;
    extraGroups."vboxusers".members = [ "alter2000" ];
  };

  virtualisation = {
    # anbox.enable = true;
    # lxc.enable = true;
    # lxd.enable = true;

    libvirtd = {
      enable = false;
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
