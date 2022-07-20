import gintro / gtk
import .. / .. / cores / handle_activities
import .. / ansurf_gtk_objects
import .. / dialogs / [ansurf_dialog_tor_status, ansurf_dialog_killapps]
import .. / .. / cores / commons / [services_status, ansurf_objects]


proc is_anonsurf_running(): bool =
  return getServStatus("anonsurfd")


proc do_anonsurf_start(cb_send_msg: callback_send_messenger) {.gcsafe.} =
  ansurf_acts_handle_start("menuexecg", cb_send_msg)


proc do_anonsurf_restart(cb_send_msg: callback_send_messenger) {.gcsafe.} =
  ansurf_acts_handle_restart("menuexecg", cb_send_msg)


proc do_anonsurf_changeid(cb_send_msg: callback_send_messenger) {.gcsafe.} =
  ansurf_acts_handle_changeID(cb_send_msg)


proc do_anonsurf_checkip(cb_send_msg: callback_send_messenger) {.gcsafe.} =
  ansurf_acts_handle_checkIP(cb_send_msg)


proc ansurf_menu_do_status*(m: MenuItem, cb_send_msg: callback_send_messenger) =
  if is_anonsurf_running():
    cb_send_msg("AnonSurf Status", "AnonSurf is running. Starting Nyx.", SecurityHigh)
    onClickTorStatus()
  else:
    cb_send_msg("AnonSurf Status", "AnonSurf is not running", SecurityMedium)


proc ansurf_menu_do_myip*(m: MenuItem, cb_send_msg: callback_send_messenger) =
  createThread(ansurf_workers_myip, do_anonsurf_checkip, (cb_send_msg))


proc ansurf_menu_do_start*(m: MenuItem, cb_send_msg: callback_send_messenger) =
  if is_anonsurf_running():
    cb_send_msg("AnonSurf Status", "AnonSurf is running. Can't start it again.", SecurityLow)
  else:
    dialog_kill_apps(cb_send_msg)
    createThread(ansurf_workers_common, do_anonsurf_start, cb_send_msg)


proc ansurf_menu_do_restart*(m: MenuItem, cb_send_msg: callback_send_messenger) =
  if not is_anonsurf_running():
    cb_send_msg("AnonSurf Status", "AnonSurf is not running. Can't restart.", SecurityLow)
  else:
    createThread(ansurf_workers_common, do_anonsurf_restart, cb_send_msg)


proc ansurf_menu_do_stop*(m: MenuItem, cb_send_msg: callback_send_messenger) =
  if not is_anonsurf_running():
    cb_send_msg("AnonSurf Status", "AnonSurf is not running. Can't stop it.", SecurityLow)
  else:
    ansurf_acts_handle_stop("menuexecg", cb_send_msg)
    if not getServStatus("anonsurfd"):
      dialog_kill_apps(cb_send_msg)


proc ansurf_menu_do_changeid*(m: MenuItem, cb_send_msg: callback_send_messenger) =
  if not is_anonsurf_running():
    cb_send_msg("AnonSurf Status", "AnonSurf is not running. Can't change id.", SecurityLow)
  else:
    createThread(ansurf_workers_common, do_anonsurf_changeid, (cb_send_msg))
    ansurf_workers_common.joinThread()
