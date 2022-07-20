import .. / cli / ansurf_cli_killapps
import .. / gtk / utils / ansurf_gtk_kill_apps
import commons / ansurf_objects


proc init_cli_askkill*(is_desktop: bool): callback_kill_apps =
  if is_desktop:
    return window_kill_app
  else:
    return cli_kill_apps
