import os
# import activities / app_kills


proc cmd_kill_apps*(callback_send_messages, handle_ansurf_sendkill: proc) =
  const
    path_bleachbit = "/usr/bin/bleachbit"
  
  let kill_result = handle_ansurf_sendkill()
  if kill_result != 0:
    callback_send_messages("Kill apps", "Some apps coudn't be killed", 1)
  
  if not fileExists(path_bleachbit):
    callback_send_messages("Kill apps", "Bleachbit is not found. Can't remove caches", 1)
  else:
    discard


proc cmd_init_cli_askkill(is_desktop: bool) =
  discard


proc cmd_init_gtk_askkill() =
  discard
