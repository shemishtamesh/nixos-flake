{
  networking = {
    hostName = "shenixtamesh"; # Define your hostname.

    networkmanager.enable = true;

    nameservers = [
      "94.140.14.14"
      "94.140.15.15"
      "2a10:50c0::ad1:ff"
      "2a10:50c0::ad2:ff"
      "1.1.1.1"
    ];
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.dns = "none";

    # Open ports in the firewall.
    firewall = {
      allowedTCPPorts = [ 8080 ];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
        # KDE Connect
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
        # KDE Connect
      ];
      # # Or disable the firewall altogether.
      # enable = false;
    };
  };
}
