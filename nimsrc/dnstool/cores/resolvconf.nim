import os
import .. / cores / dnstool_const
import .. / cli / print


proc resolvconf_exists*(): bool =
  return fileExists(resolvconf_dns_file)


proc resolvconf_create_symlink*() =
  try:
    createSymlink(resolvconf_dns_file, system_dns_file)
  except:
    print_error("Failed to create symlink from " & system_dns_file)
