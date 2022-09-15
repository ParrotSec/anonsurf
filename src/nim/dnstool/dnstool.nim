import os
import cores / [handler, utils]
import cli / [help, print]


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
  elif paramStr(1) == "address" or paramStr(1) == "addr":
    let addr_result = parse_addr_from_params(commandLineParams()[1 .. ^1])
    handle_create_dns_addr(addr_result.has_dhcp_flag, addr_result.list_addr)
  else:
    dnst_show_help()
    print_error("Invalid option")

main()
