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


proc handle_create_resolvconf_symlink() =
  if not tryRemoveFile(system_dns_file):
    print_error("Failed to remove " & system_dns_file & " to create a new one")
  else:
    resolvconf_create_symlink()


proc dnst_show_status*() =
  discard


proc handle_addr_dhcp_only() =
  if resolvconf_exists():
    handle_create_resolvconf_symlink()
  elif dhclient_binary_exists():
    dhclient_create_dhcp_dns()
  else:
    print_error("Can't find neither resolvconf nor dhclient. Try custom DNS addr.")


proc handle_addr_custom_only() =
  discard


proc handle_addr_mix_with_dhcp(list_addr: seq[string]) =
  if resolvconf_exists():
    handle_create_resolvconf_symlink()
    write_dns_to_resolvconf_tail(list_addr)
  elif dhclient_binary_exists():
    # TODO handle mixed addr of dhclient and custom
    discard
  else:
    discard # force writing custom addr only


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

  dnst_show_status()


proc handle_argv_missing*() =
  dnst_show_help()
  dnst_show_status()


proc handle_create_dns_addr*(has_dhcp: bool, list_addr: seq[string]) =
  let final_list_addr = validate_dns_addr(list_addr)
  # TODO better to do callback: write addr, call show status, .. if all proc has the same structure
  if not has_dhcp:
    if len(final_list_addr) == 0:
      print_error("There's no valid DNS addresses.")
      return
    else:
      handle_addr_custom_only()
  else:
    if len(final_list_addr) == 0:
      handle_addr_dhcp_only()
    else:
      handle_addr_mix_with_dhcp(list_addr)

  # echo "\n[*] Applied DNS settings"
  # TODO only print completed if all functions are good
  dnst_show_status()
