import killapps / [kill_apps_cli, kill_apps_gtk]
import commons / ansurf_types


proc init_cli_askkill*(is_desktop: bool): callback_kill_apps =
  if is_desktop:
    return window_kill_app
  else:
    return cli_kill_apps
