import os
import cores / [dnstool_const, dhclient, resolvconf]
import cli / [help, print]


proc system_dns_file_is_symlink(): bool =
  if getFileInfo(system_dns_file, followSymlink = false).kind == pcLinkToFile:
    return true
  return false


proc dnst_create_dhcp_dns() =
  if resolvconf_exists():
    resolvconf_create_symlink()
  elif dhclient_lease_exists():
    dhclient_create_dhcp_dns()
  else:
    print_error("Can't find neither resolvconf nor dhclient. Try custom DNS addr")


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
    print_error("Failed to create backup file")


proc dnst_restore_backup() =
  try:
    moveFile(system_dns_backup, system_dns_file)
  except:
    print_error("Failed to restore backup")


# TODO show status
# TODO write custom addr
# TODO mix dns with dhcp
proc main() =
  if paramCount() == 0:
    dnst_show_help()
    showStatus()
  elif paramCount() == 1:
    if paramStr(1) in ["help", "-h", "--help", "-help"]:
      dnst_show_help()
    elif paramStr(1) == "status":
      showStatus()
    elif paramStr(1) == "create-backup":
      dnst_create_backup()
    elif paramStr(1) == "restore-backup":
      dnst_restore_backup()
      showStatus()
    else:
      stderr.write("[!] Invalid option\n")
  else:
    if paramStr(1) == "address" or paramStr(1) == "addr":
      if paramStr(2) == "dhcp":
        dnst_create_dhcp_dns()
      else:
        var
          dnsAddr: seq[string]
        for i in 2 .. paramCount():
          if paramStr(i) == "--add":
            let current_addresses = getResolvConfAddresses()
            if current_addresses != [] and current_addresses != ["localhost"] and current_addresses != ["127.0.0.1"]:
              for address in getResolvConfAddresses():
                dnsAddr = dnsAddr.concat(current_addresses)
          else:
            dnsAddr.add(paramStr(i))

        makeCustomDNS(deduplicate(dnsAddr))
      showStatus()
      stdout.write("\n[*] Applied DNS settings\n")
    else:
      dnst_show_help()
      print_error("[!] Invalid option")
      return

main()
