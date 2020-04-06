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


proc help() =
  discard


proc status() =
  let statusResult = dnsStatusCheck()
  if statusResult == 0:
    stdout.write("Under AnonSurf\n")
  elif statusResult == -1:
    stderr.write("[x] Only using localhost\n")
  else:
    if statusResult == 20:
      stdout.write("Using static settings\n")
    elif statusResult == 21:
      stdout.write("Using static + OpenNIC addresses\n")
    elif statusResult == 22:
      stdout.write("Using static + custom addresses\n")
    elif statusResult == 23:
      stdout.write("Using static + OpenNIC + Custom addresses\n")
    elif statusResult == 10:
      stdout.write("Using dynaimc settings\n")
    elif statusResult == 11:
      stdout.write("Using dynaimc + OpenNIC addresses\n")
    elif statusResult == 12:
      stdout.write("Using dynaimc + custom addresses\n")
    elif statusResult == 13:
      stdout.write("Using dynaimc + OpenNIC + Custom addresses\n")


proc writeDNSToTail(data: string) = 
  #[
    Use append mode to write data to tail after clean tail
  ]#

  try:
    let fResolvTail = open(resolvTail, fmAppend)
    fResolvTail.write(data)
    fResolvTail.close()
  except:
    stderr.write("[x] Error while writing OpenNIC to resolv.conf tail\n")
    stderr.write("[!] Debug: Func writeDNSToTail\n")


proc writeDNSToResolv(data: string) =
  #[
    Use append mode to write data to resolv.conf
  ]#

  try:
    let fResolv = open(resolvConf, fmAppend)
    fResolv.write(data)
    fResolv.close()
  except:
    stderr.write("[x] Error while writing OpenNIC to resolv.conf\n")
    stderr.write("[!] Debug: Func writeDNSToResolv\n")


proc cleanTail() =
  #[
    We clean base, head, original, tail in /etc/resolvconf/resolv.conf.d
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
      stderr.write("Error while making new resolv.conf")
      stderr.write("[!] Debug: Func freshResolv\n")


proc doBasicMake(dynamicOpt: string) =
  freshResolv(dynamicOpt)
  cleanTail()


proc main() =
  # TODO help
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
    help()
    status()
    return
  elif paramCount() == 1:
    if paramStr(1) == "help" or paramStr(1) == "-h" or paramStr(1) == "--help":
      help()
      return
    elif paramStr(1) == "status":
      status()
      return
    elif paramStr(1) != "static" and paramStr(1) != "dynamic":
      help()
      stderr.write("[x] Err Unknow option\n")
  
  doBasicMake(paramStr(1))

  var allDNSAddress: string = ""

  if paramCount() >= 2:
    for i in 2 .. paramCount():
      if paramStr(i) == "opennic":
        if paramStr(1) == "dynamic":
          writeDNSToTail(openNICAddr)
        elif paramStr(1) == "static":
          writeDNSToResolv(openNICAddr)
      elif isIpAddress(paramStr(i)):
        allDNSAddress &= "nameserver " & paramStr(i) & "\n"
    
    if paramStr(1) == "dynamic":
      writeDNSToTail(allDNSAddress)
    elif paramStr(1) == "static":
      writeDNSToResolv(allDNSAddress)

  if paramStr(1) == "dynamic":
    if execShellCmd("resolvconf -u") == 0:
      stderr.write("[x] Error: while updating resolv.conf config\n")
      stderr.write("[!] Debug: Executing resolvconf -u error\n")

main()