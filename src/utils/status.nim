import osproc
import os
import .. / modules / [parser, encoder]
import strutils

type
  Status* = ref object
    isAnonSurfService*: int
    isTorService*: int
    isAnonSurfBoot*: bool
  PortStatus* = ref object
    isControlPort*: bool
    isDNSPort*: bool
    isSocksPort*: bool
    isTransPort*: bool


proc getStatusService*(serviceName: string): int =
  #[
    Check if service is actived
    # TODO use native check instead of subprocess
    return code
      1 active
      0 inactive
      -1 failed
  ]#
  let serviceResult = execProcess("systemctl is-active " & serviceName)
 
  if serviceResult == "active\n":
    return 1
  elif serviceResult == "inactive\n":
    return 0
  elif serviceResult == "failed\n":
    return -1


proc getEnableService*(serviceName: string): bool =
  #[
    Check if service is enabled at boot by systemd
    Todo: use native check instead of subprocess
      Enable service: Created symlink /etc/systemd/system/multi-user.target.wants/tor.service → /lib/systemd/system/tor.service.
      Disable service: Removed /etc/systemd/system/multi-user.target.wants/tor.service.
  ]#
  if fileExists("/etc/systemd/system/multi-user.target.wants/" & serviceName):
    return true
  elif fileExists("/etc/systemd/system/default.target.wants/" & serviceName):
    return true
  else:
    return false


proc getSurfStatus*(): Status =
  #[
    Get status of services (activated / inactivated)
    TODO use libdbus https://nimble.directory/pkg/dbus
  ]#
  let
    surfStatus = getStatusService("anonsurfd")
    torStatus = getStatusService("tor")
    surfEnable = getEnableService("anonsurfd.service")

  var
    finalStatus: Status
  
  finalStatus = Status(
    isAnonSurfService: surfStatus,
    isTorService: torStatus,
    isAnonSurfBoot: surfEnable,
  )

  return finalStatus


proc getStatusPorts*(): PortStatus =
  let
    openedAddr = toNixHex(getTorrcPorts())
  if not openedAddr.fileErr:
    const
      path = "/proc/net/tcp"
    let
      netstat = readFile(path)
    result.isControlPort = openedAddr.controlPort in netstat
    result.isDNSPort = openedAddr.dnsPort in netstat
    result.isSocksPort = openedAddr.socksPort in netstat
    result.isTransPort = openedAddr.transPort in netstat
