import os
import strutils
import services_status


type
  DnsAddr = enum
    LOCALHOST_ONLY, CUSTOM_ADDRESS, ERR
  DnsErr* = enum
    ERR_TOR, ERR_CUSTOM_DNS, ERR_LOCAL_HOST, ERR_FILE_NOT_FOUND, ERR_FILE_EMPTY, ERR_UNKNOWN
  DnsStatus* = object
    err*: DnsErr
    is_static*: bool
const
  sysResolvConf = "/etc/resolv.conf"


proc dnsAddressCheck(): DnsAddr =
  var
    has_localhost = false
    has_custom_addr = false

  for line in lines(sysResolvConf):
    if line.startsWith("nameserver"):
      let name_server = line.split(" ")[1]
      if name_server == "localhost" or name_server == "127.0.0.1":
        has_localhost = true
      else:
        has_custom_addr = true

  if has_custom_addr:
    return DnsAddr.CUSTOM_ADDRESS
  else:
    if has_localhost:
      return DnsAddr.LOCALHOST_ONLY
    else:
      return DnsAddr.ERR


proc dnsStatusCheck*(): DnsStatus =
  #[
    Check status of current DNS settings in /etc/resolv.conf
    1. File stat: /etc/resolv.conf is a symlink or static file? (symlink is always DHCP)
    2. DNS is localhost (Tor's DNS / any service / DNS error?).
    3. File error: file doesn't exist? File is empty?
  ]#
  var ret: DnsStatus
  if not fileExists(sysResolvConf):
    ret.err = DnsErr.ERR_FILE_NOT_FOUND
    return ret
  elif isEmptyOrWhitespace(readFile(sysResolvConf)):
    ret.err = DnsErr.ERR_FILE_EMPTY
    return ret
  else:
    if getFileInfo(sysResolvConf, followSymlink = false).kind == pcFile:
      ret.is_static = true
    else:
      ret.is_static = false
    let address_result = dnsAddressCheck()
    if address_result == DnsAddr.LOCALHOST_ONLY:
      if getServStatus("anonsurfd"):
        ret.err = DnsErr.ERR_TOR
      else:
        ret.err = DnsErr.ERR_LOCAL_HOST
    elif address_result == DnsAddr.ERR:
      ret.err = DnsErr.ERR_UNKNOWN
    else:
      ret.err = DnsErr.ERR_CUSTOM_DNS

  return ret
