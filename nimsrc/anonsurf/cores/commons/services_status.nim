import os


# proc getServStatus*(serviceName: string): int =
#   #[
#     Use return code of either `systemctl status` or `service <servicename> status
#     0 program is running or service is OK
#     1 program is dead and /var/run pid file exists
#     2 program is dead and /var/lock lock file exists
#     3 program is not running
#     4 program or service status is unknown
#     https://stackoverflow.com/q/56719780
#   ]#
#   return execShellCmd("/usr/bin/systemctl status " & serviceName & " >/dev/null")


proc getServStatus*(serviceName: string): bool =
  #[
    All activated, enabled service is at /run/systemd/units/
    Activated service is a symlink
    lrwxrwxrwx 1 root root 32 Mar  5 05:33 invocation:anonsurfd.service -> 76c26d0a0ad640278a2f45b9defcc843
  ]#
  const
    systemd_dir = "/run/systemd/units/"
  if fileExists(systemd_dir & serviceName & ".service"):
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
