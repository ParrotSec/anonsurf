import killapps / killapps_interface


# proc init_kill_app_dialog*(): Box =
#   return box_kill_app()


proc killapp_handle_cli_askkill(is_desktop: bool, cb_send_msg) =
  if is_desktop:
    window_kill_app()
  else:
    cmd_kill_apps()


proc killapp_handle_gtk_askkill() =
  discard
