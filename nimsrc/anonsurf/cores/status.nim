import .. / modules / [parser, encoder]
import strutils
import .. / .. / utils / services

type
  Status* = ref object
    isAnonSurfService*: int
    isTorService*: int
    isAnonSurfBoot*: bool
  PortStatus* = object
    isReadError*: bool
    isControlPort*: bool
    isDNSPort*: bool
    isSocksPort*: bool
    isTransPort*: bool


proc getSurfStatus*(): Status =
  #[
    Get status of services (activated / inactivated)
    TODO use libdbus https://nimble.directory/pkg/dbus
  ]#
  let
    surfStatus = getServStatus("anonsurfd")
    torStatus = getServStatus("tor")
    surfEnable = isServEnabled("anonsurfd.service")

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

  result.isReadError = openedAddr.fileErr

  if not openedAddr.fileErr:
    const
      path = "/proc/net/tcp"
    let
      netstat = readFile(path)
    result.isControlPort = netstat.contains(openedAddr.controlPort)
    result.isDNSPort = netstat.contains(openedAddr.dnsPort)
    result.isSocksPort = netstat.contains(openedAddr.socksPort)
    result.isTransPort = netstat.contains(openedAddr.transPort)
