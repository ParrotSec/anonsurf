import os
import dnstool_const
import strutils
import .. / cli / print
import sequtils
import net


proc convert_seq_addr_to_string(addresses: seq[string]): string =
  var
    dns_addr_in_text = ""
  for address in addresses:
    dns_addr_in_text &= "nameserver " & address & "\n"

  return dns_addr_in_text


proc system_dns_file_is_symlink*(): bool =
  if getFileInfo(system_dns_file, followSymlink = false).kind == pcLinkToFile:
    return true
  return false


proc parse_dns_addresses*(): seq[string] =
  for line in lines(resolvconf_dns_file):
    if line.startsWith("nameserver"):
      result.add(line.split(" ")[1])


proc write_dns_addr_to_file*(file_path: string, list_dns_addr: seq[string]) =
  let dns_addr = convert_seq_addr_to_string(deduplicate(list_dns_addr))
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
