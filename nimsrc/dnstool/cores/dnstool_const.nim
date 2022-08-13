const
  system_dns_file* = "/etc/resolv.conf"
  system_dns_backup* = "/etc/resolv.conf.bak"
  resolvconf_dns_file* = "/run/resolvconf/resolv.conf"
  dhclient_dns_file* = "/var/lib/dhcp/dhclient.leases"
  resolvconf_tail_file* = "/etc/resolvconf/resolv.conf.d/tail"
  dhclient_binary* = "/usr/sbin/dhclient"
  hook_script_dhcp_path* = "/etc/dhcp/dhclient-enter-hooks.d/dnstool"
  hook_script_dhcp_data* = "make_resolv_conf() { :; }"
  # https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/manually-configuring-the-etc-resolv-conf-file_configuring-and-managing-networking
  hook_script_nm_path* = "/etc/NetworkManager/conf.d/90-dns-none.conf"
  hook_script_nm_data* = "[main]\ndns=none\n"
  # https://www.cyberciti.biz/faq/dhclient-etcresolvconf-hooks/
  # This path only works with Debian based

type
  AddrFromParams* = object
    has_dhcp_flag*: bool
    list_addr*: seq[string]
