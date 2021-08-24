import killapps / [kill_apps_cli, kill_apps_gtk]
import ansurf_types
# type
#   callback_kill_apps* = proc(callback_send_msg: proc)


proc init_cli_askkill*(is_desktop: bool): callback_kill_apps =
  if is_desktop:
    return window_kill_app
  else:
    return cli_kill_apps


proc init_gtk_askkill*(is_desktop: bool): proc =
  return window_kill_app
