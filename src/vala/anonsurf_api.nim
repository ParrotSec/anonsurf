import cores / [check_status, parse_options]
import os

#[
  Vala crashes when Nim tries to convert strings to Nim string, or concat string (double free)
  Use hardcoded strings to avoid that
]#

proc is_anonsurf_running*(): bool {.exportc.} =
  return status_check_service_run("/run/systemd/units/invocation:anonsurfd.service")


proc is_tor_running*(): bool {.exportc.} =
  return status_check_service_run("/run/systemd/units/invocation:tor.service")


proc is_anonsurf_enabled_boot*(): bool {.exportc.} =
  if fileExists("/etc/systemd/system/multi-user.target.wants/anonsurfd.service"):
    return true
  elif fileExists("/etc/systemd/system/default.target.wants/anonsurfd.service"):
    return true
  else:
    return false
