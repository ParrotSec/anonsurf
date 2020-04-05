#[
  Take args from gui and clean + make / create DNS config
]#

import os
import utils / dnsutils


const
  openNICAddr = "185.121.177.177\n169.239.202.202\n198.251.90.108\n198.251.90.109\nnameserver 198.251.90.110"
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
    stderr.write("[x] Only using localhost")
  else:
    if statusResult == 20:
      stdout.write("Using static settings")
    elif statusResult == 21:
      stdout.write("Using static + OpenNIC addresses")
    elif statusResult == 22:
      stdout.write("Using static + custom addresses")
    elif statusResult == 23:
      stdout.write("Using static + OpenNIC + Custom addresses")
    elif statusResult == 10:
      stdout.write("Using dynaimc settings")
    elif statusResult == 11:
      stdout.write("Using dynaimc + OpenNIC addresses")
    elif statusResult == 12:
      stdout.write("Using dynaimc + custom addresses")
    elif statusResult == 13:
      stdout.write("Using dynaimc + OpenNIC + Custom addresses")


proc writeOpenNICToTail() = 
  #[
    Use append mode to write data to tail after clean tail
  ]#
  # writeFile(mainPath, openNICDNS)
  try:
    let fResolvTail = open(resolvTail, fmAppend)
    fResolvTail.write(openNICAddr)
    fResolvTail.close()
  except:
    stderr.write("Error while writing OpenNIC to Tail")


proc writeOpenNICToResolv() =
  #[
    Use append mode to write data to resolv.conf
  ]#

  # writeFile(mainPath, openNICDNS)
  try:
    let fResolvTail = open(resolvTail, fmAppend)
    fResolvTail.write(openNICAddr)
    fResolvTail.close()
  except:
    stderr.write("Error while writing OpenNIC to Tail")


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
    stderr.write("Error while removing symlink")
  else:
    try:
      if resolvType == "0":
        # Dynamic
        writeFile(resolvConf, "")
      else:
        # Static
        createSymlink(runResolvConf, resolvConf)
    except:
      stderr.write("Error while making new resolv.conf")


proc doBasicMake(dynamicOpt: string) =
  freshResolv(dynamicOpt)
  cleanTail()


proc main() =
  # TODO take agruments here
  # TODO support both GUI and CLI
  # TODO add status option
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
      stderr.write("Unknow option\n")
  
  doBasicMake(paramStr(1))

  if paramStr(1) == "dynamic":
    writeOpenNICToTail()
  elif paramStr(1) == "static":
    writeOpenNICToResolv()

  # TODO opennic and custom addresses here

main()