import os
import strutils

proc getMacIfaces(): seq[string] =
  #[
    Get all avaiable net iface in the system
      and remove localhost, docker, virtualbox interfaces
      # TODO add more virtual interfaces to remove
    return list of avaiable interface to change address (wlan, eth, ...)

  ]#
  const
    sysNetIfaces = "/sys/class/net/"
  var
    macIfaces: seq[string]
  
  for kind, path in walkDir(sysNetIfaces):
    let ifaceName = path.split("/")[^1]
    if ifaceName != "lo" and
      not ifaceName.startsWith("docker") and
      not ifaceName.startsWith("vboxnet"):
        macIfaces.add(ifaceName)
  return macIfaces
