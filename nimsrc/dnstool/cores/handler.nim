import os
import dnstool_const
import .. / cli / print
import resolvconf
import dhclient
import utils


proc dnst_create_dhcp_dns*() =
  if resolvconf_exists():
    resolvconf_create_symlink()
  elif dhclient_lease_exists():
    dhclient_create_dhcp_dns()
  else:
    print_error("Can't find neither resolvconf nor dhclient. Try custom DNS addr")


proc dnst_create_backup*() =
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
    print_error("Failed to create backup file")


proc dnst_restore_backup*() =
  try:
    moveFile(system_dns_backup, system_dns_file)
  except:
    print_error("Failed to restore backup")
