import gintro / gtk
import .. / .. / cores / handle_activities
import .. / ansurf_gtk_objects
import .. / dialogs / [ansurf_dialog_tor_status, ansurf_dialog_killapps]
import .. / .. / cores / commons / [services_status, ansurf_objects]


proc do_anonsurf_start(cb_send_msg: callback_send_messenger) {.gcsafe.} =
  ansurf_acts_handle_start("menuexecg", cb_send_msg)


proc do_anonsurf_restart(cb_send_msg: callback_send_messenger) {.gcsafe.} =
  ansurf_acts_handle_restart("menuexecg", cb_send_msg)


proc do_anonsurf_changeid(cb_send_msg: callback_send_messenger) {.gcsafe.} =
  ansurf_acts_handle_changeID(cb_send_msg)


proc do_anonsurf_checkip(cb_send_msg: callback_send_messenger) {.gcsafe.} =
  ansurf_acts_handle_checkIP(cb_send_msg)


proc ansurf_gtk_do_start_stop*(b: Button, cb_send_msg: callback_send_messenger) =
  if b.label == "Start":
    dialog_kill_apps(cb_send_msg)
    createThread(ansurf_workers_common, do_anonsurf_start, cb_send_msg)
  else:
    ansurf_acts_handle_stop("menuexecg", cb_send_msg)
    if not getServStatus("anonsurfd"):
      dialog_kill_apps(cb_send_msg)


proc ansurf_gtk_do_restart*(b: Button, cb_send_msg: callback_send_messenger) =
  createThread(ansurf_workers_common, do_anonsurf_restart, cb_send_msg)


proc ansurf_gtk_do_myip*(b: Button, cb_send_msg: callback_send_messenger) =
  createThread(ansurf_workers_myip, do_anonsurf_checkip, (cb_send_msg))


proc ansurf_gtk_do_changeid*(b: Button, cb_send_msg: callback_send_messenger) =
  createThread(ansurf_workers_common, do_anonsurf_changeid, (cb_send_msg))
  ansurf_workers_common.joinThread()


proc ansurf_gtk_do_status*(b: Button) =
  onClickTorStatus()
