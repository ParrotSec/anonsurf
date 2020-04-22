#[
  Take args from gui and clean + make / create DNS config
]#

import os
import net
import utils / dnsutils

const
  openNICAddr ="nameserver 185.121.177.177\nnameserver 169.239.202.202\nnameserver 198.251.90.108\nnameserver 198.251.90.109\nnameserver 198.251.90.110\n"
  resolvTail =  "/etc/resolvconf/resolv.conf.d/tail"
  resolvConf = "/etc/resolv.conf"
  runResolvConf = "/etc/resolvconf/run/resolv.conf"
  dhcpAddrFile = "/run/resolvconf/interface/NetworkManager" # TODO check for multiple if


proc showHelpDesc(keyword = "", descr = "") =
  #[
    Make color for description
    syntax:
      <keyword>: <description>
    keyword -> red
    description -> blue
  ]#
  var helpDesc = ""
  if keyword != "":
    helpDesc = "\e[31m" & keyword & "\e[0m: "
  helpDesc &= "\e[34m" & descr & "\e[0m"

  echo "  " & helpDesc


proc showHelpCmd(cmd = "dnstool", keyword = "help", args = "", descr = "") =
  #[
    Make color for command syntax in help bannner
    Print them in help
    Syntax: <command> <keyword> <args> [<description>]
    command -> light green
    keyword -> red
    args (optional) -> yellow
    description (optional) -> blue
  ]#
  var cmdOutput = ""
  cmdOutput &= "\e[32m" & cmd & "\e[0m " # Green color for command
  cmdOutput &= "\e[31m" & keyword & "\e[0m " # Red color for keyword
  if args != "":
    cmdOutput &= "\e[33m" & args & "\e[0m "
  if descr != "":
    cmdOutput &= "[\e[34m" & descr & "\e[0m]"
  
  echo cmdOutput

proc banner() =
  stdout.write("DNS Tool: A CLI tool to change DNS settings quickly\n")
  stdout.write("Developer: Nong Hoang \"DmKnght\" Tu <dmknght@parrotsec.org>\n")
  stdout.write("Gitlab: https://nest.parrot.sh/packages/tools/anonsurf\n")
  stdout.write("License: GPL3\n\n")


proc help() =
  banner()
  let progName = getAppFileName()
  showHelpCmd(cmd = progName, keyword = "help | -h | --help", descr = "Show help banner")
  showHelpCmd(cmd = progName, keyword = "status", descr = "Show current system DNS")
  showHelpCmd(cmd = "sudo " & progName, keyword = "dynamic", descr = "Use DHCP's DNS")
  showHelpCmd(cmd = "sudo " & progName, keyword = "dynamic", args = "<Address[es]>", descr = "Use DHCP's DNS and custom DNS address[es]")
  showHelpCmd(cmd = "sudo " & progName, keyword = "static", args = "<Address[es]>", descr = "Use custom DNS address[es]")
  stdout.write("\nAddress could be:\n")
  showHelpDesc(keyword = "opennic", descr = "OpenNIC address[es]")
  showHelpDesc(keyword = "dhcp", descr = "Address[es] of current DHCP settings")
  showHelpDesc(descr = "Any IPv4 or IPv6 address[es]")
  stdout.write("\nStatic and Dynamic:\n")
  showHelpDesc(keyword = "static", descr = "Keep DNS settings after reboot or join other network")
  showHelpDesc(keyword = "dynamic", descr = "Doesn't keep current address[es] after reboot or join new network")
  stdout.write("\n")


proc readDHCPDNS(): string =
  return readFile(dhcpAddrFile)


proc status() =
  #[
    Get current settings of DNS on system
  ]#
  stdout.write("Your system is: ")
  let statusResult = dnsStatusCheck()
  if statusResult == 0:
    stdout.write("under AnonSurf connection\n")
  elif statusResult == -1:
    stderr.write("[x] using localhost only. This might be an error\n")
  else:
    if statusResult == 20:
      stdout.write("using static setting\n")
    elif statusResult == 21:
      stdout.write("using static + OpenNIC addresses\n")
    elif statusResult == 22:
      stdout.write("using static + custom addresses\n")
    elif statusResult == 23:
      stdout.write("using static + OpenNIC + Custom addresses\n")
    elif statusResult == 10:
      stdout.write("using dynamic settings\n")
    elif statusResult == 11:
      stdout.write("using dynamic + OpenNIC addresses\n")
    elif statusResult == 12:
      stdout.write("using dynamic + custom addresses\n")
    elif statusResult == 13:
      stdout.write("using dynamic + OpenNIC + Custom addresses\n")


proc writeDNSToTail(data: string) = 
  #[
    With dynamic setting for DNS, all custom data should be in tail (didn't test base or head)
      tail is recommended
    We write data with append method so we can write custom addresses and OpenNIC (by user requires)
  ]#

  let fResolvTail = open(resolvTail, fmAppend)

  try:
    fResolvTail.write(data)
  except:
    stderr.write("[x] Error while writing OpenNIC to resolv.conf tail\n")
    stderr.write("[!] Debug: Func writeDNSToTail\n")
  finally:
    fResolvTail.close()


proc writeDNSToResolv(data: string) =
  #[
    With dynamic setting, we can write addresses into /etc/resolv.conf
    We write data with append method so we can write custom addresses and OpenNIC (by user requires)
  ]#
  let fResolv = open(resolvConf, fmAppend)

  try:
    fResolv.write(data)
  except:
    stderr.write("[x] Error while writing OpenNIC to resolv.conf\n")
    stderr.write("[!] Debug: Func writeDNSToResolv\n")
  finally:
    fResolv.close()


proc cleanTail() =
  #[
    We clean tail in /etc/resolvconf/resolv.conf.d
    Maybe we should clean base, head, original?
  ]#
  writeFile(resolvTail, "")


proc freshResolv(resolvType: string) =
  #[
    Recreate resolv.conf base on options
    1. Remove resolv.conf
    2. If create static -> Touch new file
      else (create dynamic) -> Link file from run
  ]#
  if not tryRemoveFile(resolvConf):
    stderr.write("[x] Error while removing symlink\n")
    stderr.write("[!] Debug: Func freshResolv\n")
  else:
    try:
      if resolvType == "static":
        # Dynamic
        writeFile(resolvConf, "")
      else:
        # Static
        createSymlink(runResolvConf, resolvConf)
    except:
      stderr.write("Error while making new resolv.conf\n")
      stderr.write("[!] Debug: Func freshResolv\n")


proc doBasicMake(dynamicOpt: string) =
  freshResolv(dynamicOpt)
  cleanTail()


proc main() =
  #[
    We manage DNS addresses here
    1. Generate new resolv.conf file
      a. If user choose dynamic -> Create symlink file
      b. Static -> Create new file (Not symlink)
      Both will delete resolv.conf
    2. Add DNS addresses
      A) DHCP:
        User can choose use or not use DHCP server address.
        DNS provides by DHCP server is in here /run/resolvconf/interface/NetworkManager
      B) Custom Addresses
        Write Address to tail of resolvconf or write empty.
        For static only we may can write to only /etc/resolv.conf
    Dynamic DNS needs to run `sudo resolvconf -u`
  ]#

  if paramCount() == 0:
    # If user didn't give anything, we show current status and how to use the program
    help()
    status()
    return
  elif paramCount() == 1:
    # If user provided 1 param, we check if it is help or status
    if paramStr(1) == "help" or paramStr(1) == "-h" or paramStr(1) == "--help":
      help()
      return
    elif paramStr(1) == "status":
      status()
      return
    elif paramStr(1) != "static" and paramStr(1) != "dynamic":
      # If we can't define command, interrupt here
      help()
      stderr.write("[x] Err: Unknow option\n")
  
  # We clean all base files for new settings
  doBasicMake(paramStr(1))

  if paramCount() == 1 and paramStr(1) == "static":
    stderr.write("[x] Err: Must provide address for static DNS\n")
    return

  if paramCount() == 2 and paramStr(1) == "static" and paramStr(2) == "dhcp":
    stderr.write("[-] Warn: DNS address[es] of DHCP server might not work in other network location\n")

  var allDNSAddress: string = ""

  # If there are more than dynamic and static arg only,
  # args must be server addresses option
  # we check if each addr is valid IP addr and write into file
  
  # If there is other custom options, we check if it is valid address or option
  if paramCount() >= 2:
    for i in 2 .. paramCount():
      # If user select opennic, we write addresses to good place
      if paramStr(i) == "opennic":
        if paramStr(1) == "dynamic":
          writeDNSToTail(openNICAddr)
        elif paramStr(1) == "static":
          writeDNSToResolv(openNICAddr)
      elif paramStr(i) == "dhcp":
        # If user select DHCP server, we write our DNS to setting
        if paramStr(1) == "static":
          # We only apply for static because dynamic should always have it
          writeDNSToResolv(readDHCPDNS())
      elif isIpAddress(paramStr(i)):
        allDNSAddress &= "nameserver " & paramStr(i) & "\n"
    
    if paramStr(1) == "dynamic":
      writeDNSToTail(allDNSAddress)
    elif paramStr(1) == "static":
      writeDNSToResolv(allDNSAddress)

  # We apply options even there is no custom option. It must work for both
  if paramStr(1) == "dynamic":
    # If dynamic is using, surely the DNS addr of DHCP is in here
    if execShellCmd("/usr/sbin/resolvconf -u") != 0:
      stderr.write("[x] Error: while updating resolv.conf config\n")
      stderr.write("[!] Debug: Executing resolvconf -u error\n")

  status()

main()

stdout.write("[*] Completed!\n")