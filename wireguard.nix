{ networking, ... }:

let
  serverAddr = "104.248.21.175:51820";
in

{
  # Enable Wireguard
  networking.wireguard.enable = false;
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
        publicKey = "TJhjHCiHczCQr+RqjtLQQsb+mTPed/iVQURExTGGG0c=";

        # Forward all the traffic via VPN.
        allowedIPs = [ "0.0.0.0/0" ];
        # Or forward only particular subnets
        #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

        # Set this to the server IP and port.
        endpoint = serverAddr;

        # Send keepalives every 20 seconds. Important to keep NAT tables alive.
        persistentKeepalive = 20;
      }
    ];
  };

}
