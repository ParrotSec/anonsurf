import os
import sequtils
import cores / [handler, utils]
import cli / [help, print]


# TODO show status
# TODO write custom addr
# TODO mix dns with dhcp
proc main() =
  if paramCount() == 0:
    handle_argv_missing()
  elif paramCount() == 1:
    case paramStr(1)
    of ["help", "-h", "--help", "-help"]:
      dnst_show_help()
    of "status":
      dnst_show_status()
    of "create-backup":
      handle_create_backup()
    of "restore-backup":
      handle_restore_backup()
    else:
      print_error("Invalid option " & paramStr(1))
  else:
    if paramStr(1) == "address" or paramStr(1) == "addr":
      if paramStr(2) == "dhcp":
        handle_addr_dhcp_only()
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
      dnst_show_status()
      stdout.write("\n[*] Applied DNS settings\n")
    else:
      dnst_show_help()
      print_error("[!] Invalid option")
      return

main()
