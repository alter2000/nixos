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

    oci-containers = {
      backend = "docker";
      containers = {
        epitest = {
          autoStart = true;
          image = "epitechcontent/epitest-docker:latest";
          volumes = [ "/home/alter2000/epitheq:/test" ];
        };
        ubuntu-lts.autoStart = false;
        ubuntu-lts.image = "ubuntu:20.04";
      };
    };

    docker = {
      enable = true;
      autoPrune.enable = true;
      autoPrune.flags = [ "--all" ];
    };

    libvirtd.enable = false;
    libvirtd.allowedBridges = [ "virbr0" "docker0" ];

    virtualbox.host = {
      enable = false;
      addNetworkInterface = true;
      enableExtensionPack = true;
      # headless = true;
    };

  };

}

# virtualisation.oci-containers.containers.mycroft = {
#   autoStart = false;
#   image = "mycroftai/docker-mycroft";
#   ports = [ "8181:8181" ];
#   volumes = [
#     "/home/alter2000/var/mycroft:/root/.mycroft"
#     "${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native"
#     "/home/alter2000/.config/pulse/cookie:/root/.config/pulse/cookie"
#   ];
#   environment.PULSE_SERVER = "unix:${XDG_RUNTIME_DIR}/pulse/native";
#   extraOptions = [ "--device /dev/snd" ];
# };
