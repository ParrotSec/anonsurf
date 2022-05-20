import os
import strutils

const
  system_dns_file = "/etc/resolv.conf"
  resolvconf_dns_file = "/run/resolvconf/resolv.conf"
  dhclient_dns_file = "/var/lib/dhcp/dhclient.leases"


proc resolvconf_exists(): bool =
  return fileExists(resolvconf_dns_file)


proc dhclient_lease_exists(): bool =
  return fileExists(dhclient_dns_file)


proc resolvconf_create_symlink() =
  try:
    createSymlink(resolvconf_dns_file, system_dns_file)
  except:
    echo("Failed to create symlink from " & system_dns_file)


proc dhclient_parse_dns(): string =
  for line in lines(dhclient_dns_file):
    if "domain-name-servers" in line:
      return line.split(" ")[^1].replace(";", "")


proc dhclient_create_dhcp_dns() =
  let dns_addr = dhclient_parse_dns()
  # TODO handle if it's wrong value
  try:
    writeFile(system_dns_file, "nameserver " & dns_addr)
  except:
    echo("Failed to write DNS address to " & system_dns_file)


proc dnst_create_dhcp_with_resolvconf() =
  if resolvconf_exists():
    resolvconf_create_symlink()
  elif dhclient_lease_exists():
    dhclient_create_dhcp_dns()
  else:
    echo "Can't find neither resolvconf nor dhclient. Try custom DNS addr"