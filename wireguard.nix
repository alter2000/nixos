{ networking, ... }:

let
  serverAddr = "209.97.134.36:51820";
in

{
  networking.wireguard.enable = true;
  # "wg0" is the network interface name. You can name the interface arbitrarily.
  networking.wireguard.interfaces.wg0 = {
    # Determines the IP address and subnet of the client's end of the tunnel interface.
    ips = [ "10.100.0.2/24" ];

    # Path to the private key file.
    #
    # Note: The private key can also be included inline via the privateKey option,
    # but this makes the private key world-readable; thus, using privateKeyFile is
    # recommended.
    privateKeyFile = "/home/alter2000/var/vpn/wgkey";

    peers = [
      # For a client configuration, one peer entry for the server will suffice.
      {
        # Public key of the server (not a file path).
        publicKey = "gySQ8MJbSpBQyWlRdkpU47lhSmlcHPiJlVtwvqoNhmY=";

        # Forward all the traffic via VPN.
        # allowedIPs = [ "0.0.0.0/0" ];
        # Or forward only particular subnets
        allowedIPs = [ "10.100.0.0/24" ];

        # Set this to the server IP and port.
        endpoint = serverAddr;

        # Send keepalives every 20 seconds. Important to keep NAT tables alive.
        persistentKeepalive = 20;
      }
    ];
  };

}
