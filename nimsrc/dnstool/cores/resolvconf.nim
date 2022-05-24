import os
import .. / cores / dnstool_const
import .. / cli / print
import utils


proc resolvconf_exists*(): bool =
  return fileExists(resolvconf_dns_file)


proc resolvconf_create_symlink*() =
  try:
    createSymlink(resolvconf_dns_file, system_dns_file)
  except:
    print_error("Failed to create symlink from " & system_dns_file)


proc write_dns_to_resolvconf_tail*(list_dns_addr: seq[string]) =
  write_dns_addr_to_file(resolvconf_tail_file, list_dns_addr)
