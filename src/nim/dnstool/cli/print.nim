import .. / cores / dnstool_const


proc print_error*(msg: string) =
  # Print error with color red
  echo "[\e[91m!\e[0m] \e[91m", msg, "\e[0m"


proc print_file_static*(is_static: bool) =
  if is_static:
    echo "[\e[32mSTATUS\e[0m]\n- \e[91mMethod\e[0m:\e[36m Static File\e[0m"
  else:
    echo "[\e[32mSTATUS\e[0m]\n- \e[91mMethod\e[0m:\e[36m Symlink\e[0m"


proc print_under_tor_dns*() =
  echo " \e[32mUsing Tor's DNS\e[0m"


proc print_error_resolv_not_found*() =
  echo "[\e[91mDNS error: \e[91m" & system_dns_file & "\e[0m not found"


proc print_error_resolv_empty*() =
  echo "[\e[91mDNS error\e[0m] " & system_dns_file & " empty"


proc print_error_local_host*() =
  echo  "\e[91mLocalHost only. This may cause no internet access\e[0m"


proc print_error_dns_leak*() =
  echo "\e[91m\nDetected Non-Tor address[es]. This may cause information leaks.\e[0m"


proc print_anonsurf_running*() =
  echo "- \e[91mAddress\e[0m: AnonSurf is running"


proc print_info_addresses() =
  echo "- \e[91mAddress[es]\e[0m:"


proc print_dns_addresses*(list_addr: seq[string]) =
  print_info_addresses()
  for address in list_addr:
    echo "  " & address
