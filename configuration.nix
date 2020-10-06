# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, ... }:

{
  imports = [
    ./hw-configuration.nix
    ./pkgs.nix
    ./progs.nix
    ./services.nix
    ./systemd.nix
    ./users.nix
    /etc/nixos/cachix.nix
    ./wireguard.nix
  ];

  security = {
    pam = {
      enableSSHAgentAuth = true;
      # usb.enable = true;
    };
    polkit.enable = true;
    rngd.enable = true;
    rtkit.enable = true;
    sudo = {
      enable = true;
      extraConfig = ''
        Defaults	insults
        # Defaults	rootpw
      '';
    };
  };

  nix = {
    binaryCaches = [ "https://nixcache.reflex-frp.org" ];
    binaryCachePublicKeys = [ "reflex-frp.org-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];
    allowedUsers = ["@wheel"];
    trustedUsers = ["alter2000" "root"];
    autoOptimiseStore = true;
    buildCores = 3;
    maxJobs = 3;
    gc.automatic = false;
    gc.dates = "Wed,Sun"; # man systemd.time
    optimise.automatic = true;
    optimise.dates = ["wed" "sun"];
    nixPath =
      [ "nixpkgs=channel:nixos-20.03" ]
      ++ options.nix.nixPath.default
      ;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system = {
    nixos.tags = ["alterpad"];
    stateVersion = "20.03"; # Did you read the comment?
  };
}
