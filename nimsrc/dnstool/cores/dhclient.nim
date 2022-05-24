import os
import .. / cores / dnstool_const
import .. / cli / print
import strutils


proc dhclient_lease_exists*(): bool =
  return fileExists(dhclient_dns_file)


proc dhclient_parse_dns(): string =
  for line in lines(dhclient_dns_file):
    if "domain-name-servers" in line:
      return line.split(" ")[^1].replace(";", "")


proc dhclient_create_dhcp_dns*() =
  let dns_addr = dhclient_parse_dns()
  # TODO handle if it's wrong value
  try:
    writeFile(system_dns_file, "nameserver " & dns_addr)
    # TODO create a hook script to keep this address after reboot
  except:
    print_error("Failed to write DNS address to " & system_dns_file)

