{ config, lib, pkgs, ... }:

{
  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
        macAddress = "random";
      };
      ethernet.macAddress = "random";
      dns = "systemd-resolved";
    };

    enableIPv6 = true;

    timeServers = [
      "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"
      "2.nixos.pool.ntp.org"
      "3.nixos.pool.ntp.org"
    ];
  };

  services.resolved = {
    enable = true;

    dnssec = "true";
    dnsovertls = "true";

    domains = [ "~." ];

    fallbackDns = [
      "1.1.1.1#cloudflare-dns.com"
      "1.0.0.1#cloudflare-dns.com"
    ];

    extraConfig = ''
      DNS=1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com
      DNSOverTLS=yes
      Cache=yes
      LLMNR=no
      MulticastDNS=no
    '';
  };

  services.avahi = {
    enable = false;
    nssmdns4 = false;
    nssmdns6 = false;
  };
}