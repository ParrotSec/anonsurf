import .. / cores / dnstool_const


proc print_help(cmd = "dnstool", keyword = "help", args = "", descr = "") =
  #[
    Make color for command syntax in help bannner
    Print them in help
    Syntax: <command> <keyword> <args> [<description>]
    command -> light green
    keyword -> red
    args (optional) -> yellow
    description (optional) -> blue
  ]#
  var print_text = "\e[92m" & cmd & "\e[91m " & keyword & "\e[0m "

  if args != "":
    print_text &= "\e[93m" & args & "\e[0m "
  if descr != "":
    print_text &= "[\e[94m" & descr  & "\e[0m]"

  echo print_text


proc print_desc(keyword = "", descr = "") =
  #[
    Make color for description
    syntax:
      <keyword>: <description>
    keyword -> red
    description -> blue
  ]#
  var print_text = ""
  if keyword != "":
    print_text = "\e[91m" & keyword & "\e[0m: "
  print_text &= "\e[94m" & descr & "\e[0m"

  echo "  " & print_text


proc show_banner() =
  echo("DNS Tool: A CLI tool to change DNS settings quickly")
  echo("Developer: Nong Hoang \"DmKnght\" Tu <dmknght@parrotsec.org>")
  echo("Gitlab: https://nest.parrot.sh/packages/tools/anonsurf")
  echo("License: GPL3\n")


proc dnst_show_help*() =
  let
    program_name = "dnstool"
    program_name_with_sudo = "sudo dnstool"
  show_banner()
  print_help(cmd = program_name, keyword = "help | -h | --help", descr = "Show help banner")
  print_help(cmd = program_name, keyword = "status", descr = "Show current system DNS")
  print_help(cmd = program_name_with_sudo, keyword = "address", args = "<DNS servers>" , descr = "Set DNS servers")
  print_help(cmd = program_name_with_sudo, keyword = "create-backup", descr = "Make backup for current " & system_dns_file)
  print_help(cmd = program_name_with_sudo, keyword = "restore-backup", descr = "Restore backup of " & system_dns_file)
  echo("\nAddress could be:")
  print_desc(keyword = "dhcp", descr = "Address[es] of current DHCP client.")
  print_desc(descr = "Any IPv4 or IPv6 address[es]")
  echo("\nStatic file and Symlink:")
  print_desc(keyword = "Symlink", descr = "A symlink of " & resolvconf_dns_file)
  print_desc(keyword = "Static file", descr = system_dns_file & " is a file")
  stdout.write("\n")
