import os
import dnstool_const
import .. / cli / [print, help]
import resolvconf
import dhclient
import utils


proc hookscript_dnstool_exists(): bool =
  return fileExists(hook_script_path)


proc handle_hook_script_remove() =
  #[
    If system is not using resolvconf
    and hook script exists, we remove it
    The logic to check resolvconf exists and
    dhclient exists should be covered by other func
  ]#
  if hookscript_dnstool_exists():
    if not tryRemoveFile(hook_script_path):
      print_error("Error while removing hook script of dnstool")


proc handle_hookscript_create_new() =
  #[
    If system is not using resolvconf
    create a hook script to keep custom addr
    The logic to check resolvconf exists and
    dhclient exists should be covered by other func
  ]#
  try:
    writeFile(hook_script_path, hook_script_data)
  except:
    print_error("Error while making new hook script")


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
  if not system_resolvconf_exists():
    print_error_resolv_not_found()
    return

  check_system_dns_is_static()

  let
    addresses = parse_dns_addresses()

  if len(addresses) == 0:
    print_error_resolv_empty()
  elif anonsurf_is_running():
    if has_only_localhost(addresses):
      print_under_tor_dns()
    else:
      print_error_dns_leak()
  else:
    if has_only_localhost(addresses):
      print_error_local_host()
    else:
      print_dns_addresses(addresses)


proc handle_create_backup*() =
  if not system_resolvconf_exists():
    print_error("Skip creating backup file. Missing " & system_dns_file)
    return

  if system_has_only_localhost():
    print_error("Skip creating backup file. System has only localhost.")
    return

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
  else:
    print_error("Skip creating backup file because " & system_dns_file & " is a symlink.")


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

  if resolvconf_exists():
    handle_hook_script_remove()
  else:
    handle_hookscript_create_new()
  # echo "\n[*] Applied DNS settings"
  # TODO only print completed if all functions are good
  dnst_show_status()
