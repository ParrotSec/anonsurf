# import osproc
import os
import strutils
import services


const
  ERROR_UNKNOWN* = -4
  ERROR_FILE_NOT_FOUND* = -3
  ERROR_FILE_EMPTY* = -2
  ERROR_DNS_LOCALHOST* = -1
  STT_DNS_TOR* = 0
  # dhcpResolvConf = "/run/resolvconf/interface/NetworkManager"
  sysResolvConf = "/etc/resolv.conf"


proc checkDNSServers(path: string): int =
  #[
    Check for all DNS servers in path
    Return subcode:
      0: No other DNS setting
      1: Using OpenNIC
      2: Using custom
      3: Use both OpenNIC and custom
  ]#
  result = 0
  var
    isLocalHost = false
    length = 0
    
  let
    # dnsDHCP = execProcess("nmcli dev show | grep 'DNS'  | awk '{print $2}'")
    # dnsDHCP = readFile(dhcpResolvConf)
    dnsOpenNIC = "185.121.177.177\n169.239.202.202"

  for line in lines(path):
    if line.startsWith("nameserver"):
      length += 1
      let dnsName = line.split(" ")[1]
      # if current DNS is provided by DHCP server -> dynamic only
      # if dnsName in dnsDHCP:
      #   discard
      # if DNS is in list of OpenNIC
      # elif dnsName in dnsOpenNIC:
      if dnsName in dnsOpenNIC:
        if result == 0 or result == 2:
          # Don't add if the result was added
          result += 1
      elif dnsName == "127.0.0.1" or dnsName == "localhost":
        isLocalHost = true
      # Custom name server
      else:
      # We don't add if name result was added
        if result == 0 or result == 1:
          result += 2
  if length == 0:
    return ERROR_FILE_EMPTY
  if isLocalHost == true and length == 1:
    return ERROR_DNS_LOCALHOST


proc dnsStatusCheck*(): int =
  #[
    Check current system DNS settings.
    1. localhost ->  possibly under Tor
    2. Dynamic settings. Auto get new address after plug into 1 network
    3. Static settings. We use OpenicDNS here or custom by users
  ]#

  #[
    Return code:
      0: AnonSurf DNS (running)
      -1: Localhost only
      -2: File not found
      -3: File is empty
      10: Static
        1.0: Static only?
        1.1: OpenNIC
        1.2: Custom
        1.3: Custom with OpenNIC
      20: Dynamic
        2.0: DCHP only
        2.1: DHCP with OpenNIC
        2.2: DHCP with Custom
        2.3: DHCP with OpenNIC and Custom
  ]#
  if not fileExists(sysResolvConf):
    return ERROR_FILE_NOT_FOUND
  elif isEmptyOrWhitespace(readFile(sysResolvConf)):
    return ERROR_FILE_EMPTY
  else:
    try:
      let
        resolvInfo = getFileInfo(sysResolvConf, followSymlink = false)
        dnsCheck = checkDNSServers(sysResolvConf)

      if dnsCheck == ERROR_DNS_LOCALHOST:
        if getServStatus("anonsurfd") == 1:
          return STT_DNS_TOR
        else:
          return ERROR_DNS_LOCALHOST
      elif dnsCheck == ERROR_FILE_EMPTY:
        return ERROR_FILE_EMPTY
      # If resolv.conf is a file: static else dynamic
      if resolvInfo.kind == pcFile:
        result = 10
        if result == 10:
          result += dnsCheck
      else:
        # Set return value is dynamic value
        result = 20
        # Check for different settings in base files
        if result == 20:
          result += dnsCheck
      # return "Dynamic"
    except:
      return ERROR_UNKNOWN
