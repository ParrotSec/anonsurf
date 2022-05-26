import os
import dnstool_const
import .. / cli / [print, help]
import resolvconf
import dhclient
import utils


proc create_backup() =
  try:
    copyFile(system_dns_file, system_dns_backup)
  except:
    print_error("Failed to create backup file")


proc restore_backup() =
  try:
    moveFile(system_dns_backup, system_dns_file)
  except:
    print_error("Failed to restore backup")


proc handle_create_resolvconf_symlink() =
  if not tryRemoveFile(system_dns_file):
    print_error("Failed to remove " & system_dns_file & " to create a new one")
  else:
    resolvconf_create_symlink()


proc handle_addr_dhcp_only() =
  if resolvconf_exists():
    handle_create_resolvconf_symlink()
  elif dhclient_binary_exists():
    dhclient_create_dhcp_dns()
  else:
    print_error("Can't find neither resolvconf nor dhclient. Try custom DNS addr.")


proc handle_addr_custom_only(list_addr: seq[string]) =
  if not tryRemoveFile(system_dns_file):
    print_error("Failed to remove " & system_dns_file & " to create new one.")
  write_dns_to_system(list_addr)


proc handle_addr_mix_with_dhcp(list_addr: seq[string]) =
  if resolvconf_exists():
    handle_create_resolvconf_symlink()
    write_dns_to_resolvconf_tail(list_addr)
  elif dhclient_binary_exists():
    var
      list_combo_addr = list_addr
    list_combo_addr.add(dhclient_parse_dns())
    write_dns_to_system(list_addr)
  else:
    print_error("Resolvconf and dhclient not found in the system. Force using custom address only.")
    handle_addr_custom_only(list_addr)


proc dnst_show_status*() =
  # TODO complete here
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
    create_backup()


proc handle_restore_backup*() =
  if not tryRemoveFile(system_dns_file):
    print_error("Failed to remove " & system_dns_file & " to restore backup.")
  if fileExists(system_dns_backup):
    restore_backup()
  else:
    handle_addr_dhcp_only()

  dnst_show_status()


proc handle_argv_missing*() =
  dnst_show_help()
  dnst_show_status()


proc handle_create_dns_addr*(has_dhcp: bool, list_addr: seq[string]) =
  if not has_dhcp:
    handle_addr_custom_only(list_addr)
  else:
    if len(list_addr) == 0:
      handle_addr_dhcp_only()
    else:
      handle_addr_mix_with_dhcp(list_addr)

  # echo "\n[*] Applied DNS settings"
  # TODO only print completed if all functions are good
  dnst_show_status()
