import os
import strutils
import cores / dnstool_const


proc resolvconf_exists(): bool =
  return fileExists(resolvconf_dns_file)


proc dhclient_lease_exists(): bool =
  return fileExists(dhclient_dns_file)


proc system_dns_file_is_symlink(): bool =
  if getFileInfo(system_dns_file, followSymlink = false).kind == pcLinkToFile:
    return true
  return false


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
    # TODO create a hook script to keep this address after reboot
  except:
    echo("Failed to write DNS address to " & system_dns_file)


proc dnst_create_dhcp_with_resolvconf() =
  if resolvconf_exists():
    resolvconf_create_symlink()
  elif dhclient_lease_exists():
    dhclient_create_dhcp_dns()
  else:
    echo "Can't find neither resolvconf nor dhclient. Try custom DNS addr"


proc dnst_create_backup() =
  if system_dns_file_is_symlink():
    #[
      /etc/resolv.conf is a symlink of resolvconf which is at
      /run/resolvconf/resolv.conf so we don't create backup here
      When there's no backup, dnstool will try create DHCP's DNS
      which should create a symlink if resolvconf is installed
    ]#
    return

  try:
    copyFile(system_dns_file, system_dns_backup)
  except:
    echo("Failed to create backup file")


proc dnst_restore_backup() =
  try:
    moveFile(system_dns_backup, system_dns_file)
  except:
    echo("Failed to restore backup")
