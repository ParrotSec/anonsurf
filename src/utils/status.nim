import osproc

type
  Status* = ref object
    isAnonSurfService: int
    isTorService: int
    isAnonSurfBoot: bool


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
  if serviceResult == "active":
    return 1
  elif serviceResult == "inactive":
    return 0
  elif serviceResult == "failed":
    return -1


proc getEnableService(serviceName: string): bool =
  #[
    Check if service is enabled at boot by systemd
    Todo: use native check instead of subprocess
      Enable service: Created symlink /etc/systemd/system/multi-user.target.wants/tor.service → /lib/systemd/system/tor.service.
      Disable service: Removed /etc/systemd/system/multi-user.target.wants/tor.service.
  ]#
  let serviceResult = execProcess("systemctl is-enabled " & serviceName)
  if serviceResult == "disabled":
    return false
  elif serviceResult == "enabled":
    return true


proc getSurfStatus*(): Status =
  let
    surfStatus = getStatusService("anonsurfd")
    torStatus = getStatusService("tor")
    surfEnable = getEnableService("anonsurfd")

  var
    finalStatus: Status
  
  finalStatus = Status(
    isAnonSurfService: surfStatus,
    isTorService: torStatus,
    isAnonSurfBoot: surfEnable,
  )

  return finalStatus