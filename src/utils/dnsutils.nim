import osproc
import strutils

proc dnsStatusCheck*(): string =
  #[
    Check current system DNS settings.
    1. localhost ->  possibly under Tor
    2. Dynamic settings. Auto get new address after plug into 1 network
    3. Static settings. We use OpenicDNS here or custom by users
  ]#
  const path = "/etc/resolv.conf"
  let dnsSettings = readFile(path)
  if dnsSettings == "nameserver 127.0.0.1\n":
    #[
      System is using localhost DNS settings.
      1. If anonsurf is running, return AnonSurf and disable buttons
      2. If anonsurf is not running, return localhost, red text
    ]#
    let anonsurfStatus = execProcess("systemctl is-active anonsurfd").replace("\n", "")
    if anonsurfStatus == "actived":
      return "AnonSurf DNS"
    else:
      # TODO use red color here
      return "localhost"
  else:
    #[
      Check if system is using dynamic setting (default of Debian) or static
      If static, check OpenNIC setting or custom setting
      /etc/anonsurf/opennic.lock exists -> system is using OpenNIC DNS
      Verify it by comparing /etc/anonsurf/resolv.conf.opennic?
      If ln -s /run/resolvconf/resolv.conf /etc/resolv.conf -> dynamic
    ]#
    discard # TODO check static or dynamic here