const
  system_dns_file* = "/etc/resolv.conf"
  system_dns_backup* = "/etc/resolv.conf.bak"
  resolvconf_dns_file* = "/run/resolvconf/resolv.conf"
  dhclient_dns_file* = "/var/lib/dhcp/dhclient.leases"
  resolvconf_tail_file* = "/etc/resolvconf/resolv.conf.d/tail"
  dhclient_binary* = "/usr/sbin/dhclient"
  hook_script_path* = "/etc/dhcp/dhclient-enter-hooks.d/anonsurf"
  hook_script_data* = "make_resolv_conf() { :; }"
  # https://www.cyberciti.biz/faq/dhclient-etcresolvconf-hooks/
  # This path only works with Debian based
  hook_script_resolvconf* = "/etc/dhcp/dhclient-enter-hooks.d/resolvconf"

type
  AddrFromParams* = object
    has_dhcp_flag*: bool
    list_addr*: seq[string]
