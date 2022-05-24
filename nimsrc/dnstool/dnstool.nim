import os
import sequtils
import cores / [handler, utils]
import cli / [help, print]


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
            let current_addresses = parse_dns_addresses()
            if current_addresses != [] and current_addresses != ["localhost"] and current_addresses != ["127.0.0.1"]:
              for address in parse_dns_addresses():
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
