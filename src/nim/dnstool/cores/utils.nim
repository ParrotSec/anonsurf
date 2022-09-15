import os
import dnstool_const
import strutils
import .. / cli / print
import sequtils
import net
import .. / .. / anonsurf / cores / commons / services_status


proc convert_seq_addr_to_string(addresses: seq[string]): string =
  var
    dns_addr_in_text = ""
  for address in addresses:
    dns_addr_in_text &= "nameserver " & address & "\n"

  return dns_addr_in_text


proc has_only_localhost*(list_addr: seq[string]): bool =
  if len(list_addr) == 1 and (list_addr[0] == "localhost" or list_addr[0] == "127.0.0.1"):
    return true
  return false


proc system_dns_file_is_symlink*(): bool =
  if getFileInfo(system_dns_file, followSymlink = false).kind == pcLinkToFile:
    return true
  return false


proc parse_dns_addresses*(): seq[string] =
  for line in lines(system_dns_file):
    if line.startsWith("nameserver"):
      result.add(line.split(" ")[1])


proc system_has_only_localhost*(): bool =
  let
    addresses = parse_dns_addresses()

  return has_only_localhost(addresses)


proc system_has_only_localhost_or_empty_dns*(): bool =
  let
    addresses = parse_dns_addresses()

  if len(addresses) == 0:
    return true
  return has_only_localhost(addresses) 


proc anonsurf_is_running*(): bool =
  return getServStatus("anonsurfd")


proc tor_is_running*(): bool =
  return getServStatus("tor")


proc create_backup*() =
  try:
    copyFile(system_dns_file, system_dns_backup)
  except:
    print_error("Failed to create backup file")


proc restore_backup*() =
  try:
    moveFile(system_dns_backup, system_dns_file)
  except:
    print_error("Failed to restore backup")


proc do_restore_backup*() =
  if not tryRemoveFile(system_dns_file):
    print_error("Failed to remove " & system_dns_file & " to restore backup.")
  if fileExists(system_dns_backup):
    restore_backup()


proc resolv_config_is_not_symlink*(): bool =
  return if getFileInfo(system_dns_file, followSymlink = false).kind == pcLinkToFile: false else: true


proc check_system_dns_is_static*() =
  print_file_static(resolv_config_is_not_symlink())


proc write_dns_addr_to_file*(file_path: string, list_dns_addr: seq[string]) =
  let
    deduplicated_list_addr = deduplicate(list_dns_addr)
  if len(deduplicated_list_addr) == 0:
    print_error("No valid DNS address is found.")
    return

  let
    dns_addr = convert_seq_addr_to_string(deduplicated_list_addr)
  try:
    writeFile(file_path, "# Written by DNSTool\n" & dns_addr)
  except:
    print_error("Error while writing DNS address to " & file_path)


proc write_dns_to_system*(list_dns_addr: seq[string]) =
  write_dns_addr_to_file(system_dns_file, list_dns_addr)


proc parse_addr_from_params*(params: seq[string]): AddrFromParams =
  var param_result = AddrFromParams(
    has_dhcp_flag: false
  )

  for value in params:
    if value == "dhcp":
      param_result.has_dhcp_flag = true
    elif isIpAddress(value):
      param_result.list_addr.add(value)

  return param_result


proc system_resolvconf_exists*(): bool =
  return fileExists(system_dns_file)
