import os
import activities / app_kills


proc cmd_kill_apps*(callback_send_messages: proc) =
  const
    path_bleachbit = "/usr/bin/bleachbit"
  
  let kill_result = ansurf_kill_sendkill()
  if kill_result != 0:
    callback_send_messages("Kill apps", "Some apps coudn't be killed", 1)
  
  if not fileExists(path_bleachbit):
    callback_send_messages("Kill apps", "Bleachbit is not found. Can't remove caches", 1)
  else:
    discard