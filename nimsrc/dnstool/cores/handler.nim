import os
import dnstool_const
import .. / cli / [print, help]
import resolvconf
import dhclient
import utils


proc dnst_create_backup() =
  try:
    copyFile(system_dns_file, system_dns_backup)
  except:
    print_error("Failed to create backup file")


proc dnst_restore_backup() =
  try:
    moveFile(system_dns_backup, system_dns_file)
  except:
    print_error("Failed to restore backup")


proc handle_addr_dhcp_only*() =
  if resolvconf_exists():
    resolvconf_create_symlink()
  elif dhclient_binary_exists():
    dhclient_create_dhcp_dns()
  else:
    print_error("Can't find neither resolvconf nor dhclient. Try custom DNS addr")


proc handle_addr_custom_only*() =
  discard


proc handle_addr_mix_with_dhcp*() =
  discard


proc handle_create_backup*() =
  if fileExists(system_dns_backup):
    if not tryRemoveFile(system_dns_backup):
      print_error("Failed to remove " & system_dns_backup & " to create new one.")

  if not system_dns_file_is_symlink():
    #[
      /etc/resolv.conf is a symlink of resolvconf which is at
      /run/resolvconf/resolv.conf so we don't create backup here
      When there's no backup, dnstool will try create DHCP's DNS
      which should create a symlink if resolvconf is installed
    ]#
    dnst_create_backup()


proc handle_restore_backup*() =
  if fileExists(system_dns_backup):
    dnst_restore_backup()
  else:
    discard # TODO dhcp here


proc handle_argv_missing*() =
  dnst_show_help()
  # TODO show help here
