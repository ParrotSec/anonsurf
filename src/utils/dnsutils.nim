import osproc
import os
import strutils


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
  for line in lines(path):
    if line.startsWith("#"):
      # We skip comments
      discard
    elif line == "options rotate":
      discard
    # Check empty line
    elif isNilOrWhitespace(line):
      discard
    # Check if OpenNIC DNS is in the setting
    elif line == "nameserver 185.121.177.177" or
      line == "nameserver 169.239.202.202" or
      line == "nameserver 198.251.90.108" or
      line == "nameserver 198.251.90.109" or
      line == "nameserver 198.251.90.110": # TODO check DNNS
      if result == 0 or result == 2:
        # Don't add if the result was added
        result += 1
    elif line.startsWith("nameserver"):
      # TODO: homegateway makes a bug here.
      # Custom name server
      # We don't add if name result was added
      if result == 0 or result == 1:
        result += 2


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
  const resolvPath = "/etc/resolv.conf"
  if not existsFile(resolvPath):
    result = 2
  let dnsSettings = readFile(resolvPath)
  if dnsSettings == "nameserver 127.0.0.1\n":
    #[
      System is using localhost DNS settings.
      1. If anonsurf is running, return AnonSurf and disable buttons
      2. If anonsurf is not running, return localhost, red text
    ]#
    let anonsurfStatus = execProcess("systemctl is-active anonsurfd").replace("\n", "")
    if anonsurfStatus == "actived":
      result = 0
    else:
      # TODO use red color here
      result = -1
  else:
    #[
      Check if system is using dynamic setting (default of Debian) or static
      If static, check OpenNIC setting or custom setting
      /etc/anonsurf/opennic.lock exists -> system is using OpenNIC DNS
      Verify it by comparing /etc/anonsurf/resolv.conf.opennic?
      If ln -s /run/resolvconf/resolv.conf /etc/resolv.conf -> dynamic
    ]#
    let resolvInfo = getFileInfo(resolvPath, followSymlink = false)
    # If resolv.conf is a file: static else dynamic
    if resolvInfo.kind == pcFile:
      result = 10
      if result == 10:
        result += checkDNSServers(resolvPath)
    else:
      # Set return value is dynamic value
      result = 20
      # Check for different settings in base files
      if result == 20:
        result += checkDNSServers(resolvPath)
      # return "Dynamic"