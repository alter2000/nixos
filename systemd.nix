{ config, pkgs, ... }:

let
  arbtt = {
    package = (import (fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-20.03.tar.gz)
      {}).pkgs.haskellPackages.arbtt;
    logFile = "%h/.local/share/arbtt/capture.log";
    sampleRate = 60;
  };

  lcfg = (if builtins.pathExists ./local.nix then ./local.nix else {});
in

{
  environment.systemPackages = [ arbtt.package ];
  systemd.user = {
    services = {

      arbtt = {
        description = "arbtt statistics capture service";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${arbtt.package}/bin/arbtt-capture --logfile=${arbtt.logFile} --sample-rate=${toString arbtt.sampleRate}";
          Restart = "always";
          RestartSec = 2;
        };
      };

      dunst = {
        enable = true;
        description = "dunst service";
        wantedBy = [ "default.target" ];
        partOf = [ "graphical-session.target" ];
        path = [ pkgs.dunst ];
        serviceConfig = {
          ExecStart = "${pkgs.dunst}/bin/dunst";
          Restart = "always";
          RestartSec = 1;
        };
      };

      mpd = {
        enable = true;
        description = "music player daemon";
        wantedBy = [ "default.target" ];
        path = [ pkgs.mpd ];
        serviceConfig = {
          ExecStart = "${pkgs.mpd}/bin/mpd --no-daemon";
          Type = "notify";
          # allow MPD to use real-time priority 50
          LimitRTPRIO = 50;
          LimitRTTIME = "infinity";

          # more paranoid security settings
          NoNewPrivileges = "yes";
          ProtectKernelTunables = "yes";
          ProtectControlGroups = "yes";
          # AF_NETLINK is required by libsmbclient, or it will exit() .. *sigh*
          RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX AF_NETLINK";
          RestrictNamespaces = true;
        };
      };

      picom = {
        enable = true;
        description = "custom picom service";
        wantedBy = [ "default.target" ];
        partOf = [ "graphical-session.target" ];
        path = [ pkgs.compton ];
        serviceConfig = {
          ExecStart = "${pkgs.picom}/bin/picom";
          Restart = "always";
          RestartSec = 3;
        };
      };

      sxhkd = {
        enable = true;
        description = "hotkey daemon user service";
        wantedBy = [ "default.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.sxhkd}/bin/sxhkd";
          ExecReload = "${pkgs.utillinux}/bin/kill -SIGUSR1 $MAINPID";
          Restart = "always";
          RestartSec = 2;
        };
      };

      polkit-agent = {
        enable = lcfg.systemd.user.services.polkit-agent.enable or true;
        description = "polkit auth daemon user service";
        wantedBy = [ "default.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = lcfg.systemd.user.services.polkit-agent.execStart or "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
          ExecReload = "${pkgs.utillinux}/bin/kill -SIGUSR1 $MAINPID";
          Restart = "always";
          RestartSec = 2;
        };
      };

      mpris-proxy = {
        description = "Mpris proxy";
        after = [ "network.target" "sound.target" ];
        serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
        wantedBy = [ "default.target" ];
      };

      xcape = {
        description = "xcape daemonized";
        serviceConfig.ExecStart = "${pkgs.xcape}bin/xcape -t 200 -e 'Caps_Lock=Escape' -d";
      };

    };

    timers = {
      "1minute" = {
        enable = true;
        description = "1 minute timer";
        wantedBy = [ "default.target" ];
        timerConfig = {
          Persistent = true;
          OnCalendar = "";
          Unit = "offlineimap.service";
        };
        unitConfig.refuseManualStart = false;
        unitConfig.refuseManualStop = false;
      };
    };

  };
}
