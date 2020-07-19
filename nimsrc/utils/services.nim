import osproc
import os


proc getServStatus*(serviceName: string): int =
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


proc isServEnabled*(serviceName: string): bool =
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
