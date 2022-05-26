const
  system_dns_file* = "/etc/resolv.conf"
  system_dns_backup* = "/etc/resolv.conf.bak"
  resolvconf_dns_file* = "/run/resolvconf/resolv.conf"
  dhclient_dns_file* = "/var/lib/dhcp/dhclient.leases"
  resolvconf_tail_file* = "/etc/resolvconf/resolv.conf.d/tail"
  dhclient_binary* = "/usr/sbin/dhclient"

type
  AddrFromParams* = object
    has_dhcp_flag*: bool
    list_addr*: seq[string]
