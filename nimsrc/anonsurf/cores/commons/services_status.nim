import os


proc getServStatus*(serviceName: string): int =
  #[
    Use return code of either `systemctl status` or `service <servicename> status
    0 program is running or service is OK
    1 program is dead and /var/run pid file exists
    2 program is dead and /var/lock lock file exists
    3 program is not running
    4 program or service status is unknown
    https://stackoverflow.com/q/56719780
  ]#
  return execShellCmd("/usr/bin/systemctl status " & serviceName & " >/dev/null")


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
