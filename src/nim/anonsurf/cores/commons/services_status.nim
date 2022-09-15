import os
import posix


proc getServStatus*(serviceName: string): bool =
  #[
    All activated, enabled service is at /run/systemd/units/
    Activated service is a BROKEN symlink
    lrwxrwxrwx 1 root root 32 Mar  5 05:33 invocation:anonsurfd.service -> 76c26d0a0ad640278a2f45b9defcc843
  ]#
  const
    systemd_dir = "/run/systemd/units/"
  var
    file_stat: Stat
  let
    service_path = systemd_dir & "invocation:" & serviceName & ".service"

  # The file path is a broken symlink
  # Seems like Nim's fileExists checks for actual file from symlink so this
  # broken symlink always return false.
  # Use lstat for more accurate check. lstat returns 0 -> file exists. -1 -> doesn't exist
  if lstat(cstring(service_path), file_stat) == 0:
    return true
  return false


proc isServEnabled*(serviceName: string): bool =
  #[
    Check if service is enabled at boot by systemd
    Enable service: Created symlink /etc/systemd/system/multi-user.target.wants/tor.service → /lib/systemd/system/tor.service.
    Disable service: Removed /etc/systemd/system/multi-user.target.wants/tor.service.
  ]#
  if fileExists("/etc/systemd/system/multi-user.target.wants/" & serviceName):
    return true
  elif fileExists("/etc/systemd/system/default.target.wants/" & serviceName):
    return true
  else:
    return false



proc checkInitSystem*(): bool =
  # Check if systemd / sysvinit, .. is available on  the system
  # Systemd / sysvinit should have PID 1
  return dirExists("/proc/1")
