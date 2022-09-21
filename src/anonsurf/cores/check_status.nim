import os
import posix


# const
#   systemd_dir = "/run/systemd/units/"
#   systemd_target_multi_user = "/etc/systemd/system/multi-user.target.wants/"
#   systemd_target_default = "/etc/systemd/system/default.target.wants/"


proc status_check_service_run*(service_path: string): bool =
  # let
  #   service_absolute_path = systemd_dir & "invocation:" & service_name & ".service"

  var
    file_stat: Stat

  if lstat(cstring(service_path), file_stat) == 0:
    return true
  return false


# proc status_check_service_enabled*(service_name: string): bool =
#   if fileExists(systemd_target_default & service_name):
#     return true
#   elif fileExists(systemd_target_multi_user & service_name):
#     return true
#   else:
#     return false


proc status_check_has_init_system*(): bool =
  return dirExists("/proc/1/")
