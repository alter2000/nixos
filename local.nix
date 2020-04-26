{
  services.fprintd.enable = true;
  networking.hostName = "alterpad";
  systemd.user.services.polkit-agent = {
    enable = true;
    execStart = "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
  };
}
