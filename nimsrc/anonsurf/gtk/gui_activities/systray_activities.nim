import gintro / gtk
import .. / .. / cores / handle_activities
import .. / ansurf_gtk_objects
import .. / dialogs / ansurf_dialog_tor_status
import .. / .. / cores / commons / services_status
import .. / .. / cores / killapps / kill_apps_dialog


proc is_anonsurf_running(): bool =
  return getServStatus("anonsurfd")


proc do_anonsurf_start(cb_send_msg: proc) {.gcsafe.} =
  ansurf_acts_handle_start("menuexecg", cb_send_msg)


proc do_anonsurf_restart(cb_send_msg: proc) {.gcsafe.} =
  ansurf_acts_handle_restart("menuexecg", cb_send_msg)


proc do_anonsurf_changeid(cb_send_msg: proc) {.gcsafe.} =
  ansurf_acts_handle_changeID(cb_send_msg)


proc do_anonsurf_checkip(cb_send_msg: proc) {.gcsafe.} =
  ansurf_acts_handle_checkIP(cb_send_msg)


proc ansurf_menu_do_status*(m: MenuItem, cb_send_msg: proc) =
  if is_anonsurf_running():
    onClickTorStatus()
  else:
    cb_send_msg("AnonSurf Status", "AnonSurf is not running", 1)


proc ansurf_menu_do_myip*(m: MenuItem, cb_send_msg: proc) =
  createThread(ansurf_workers_myip, do_anonsurf_checkip, (cb_send_msg))


proc ansurf_menu_do_start*(m: MenuItem, cb_send_msg: proc) =
  if is_anonsurf_running():
    cb_send_msg("AnonSurf Status", "AnonSurf is running. Can't start it again.", 2)
  else:
    dialog_kill_app(cb_send_msg)
    createThread(ansurf_workers_common, do_anonsurf_start, cb_send_msg)


proc ansurf_menu_do_restart*(m: MenuItem, cb_send_msg: proc) =
  if not is_anonsurf_running():
    cb_send_msg("AnonSurf Status", "AnonSurf is not running. Can't restart.", 2)
  else:
    createThread(ansurf_workers_common, do_anonsurf_restart, cb_send_msg)


proc ansurf_menu_do_stop*(m: MenuItem, cb_send_msg: proc) =
  if not is_anonsurf_running():
    cb_send_msg("AnonSurf Status", "AnonSurf is not running. Can't stop it.", 2)
  else:
    ansurf_acts_handle_stop("menuexecg", cb_send_msg)
    if not getServStatus("anonsurfd"):
      dialog_kill_app(cb_send_msg)


proc ansurf_menu_do_changeid*(m: MenuItem, cb_send_msg: proc) =
  if not is_anonsurf_running():
    cb_send_msg("AnonSurf Status", "AnonSurf is not running. Can't change id.", 2)
  else:
    createThread(ansurf_workers_common, do_anonsurf_changeid, (cb_send_msg))
    ansurf_workers_common.joinThread()