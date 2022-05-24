import .. / cores / dnstool_const


proc print_error*(msg: string) =
  # Print error with color red
  echo "[\e[91m!\e[0m] \e[91m", msg, "\e[0m"


proc print_file_status*(is_static: bool) =
  if is_static:
    echo "[\e[32mSTATUS\e[0m]\n- \e[91mMethod\e[0m: \e[36m Static File\e[0m"
  else:
    echo "[\e[32mSTATUS\e[0m]\n- \e[91mMethod\e[0m: \e[36m Symlink\e[0m"


proc print_under_tor_dns*(address: string) =
  echo "  " & address & " \e[32mUsing Tor's DNS\e[0m"


proc print_warn_not_using_tor_dns*(address: string) =
  echo "  " & address & " \e[91mNot a Tor DNS server.\e[0m"


proc print_error_resolv_not_found*() =
  echo "[\e[91mDNS error: \e[91m" & system_dns_file & "\e[0m not found"
