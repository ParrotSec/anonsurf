import gintro / gtk
import .. / .. / cores / handle_activities
import .. / ansurf_objects
import .. / widgets / tor_status_widget
import .. / .. / cores / commons / services_status
import .. / .. / cores / killapps / kill_apps_dialog


proc do_anonsurf_start(cb_send_msg: proc) {.gcsafe.} =
  ansurf_acts_handle_start("menuexecg", cb_send_msg)


# proc do_anonsurf_stop(cb_send_msg: proc) {.gcsafe.} =
#   ansurf_acts_handle_stop("menuexecg", cb_send_msg)


proc do_anonsurf_restart(cb_send_msg: proc) {.gcsafe.} =
  ansurf_acts_handle_restart("menuexecg", cb_send_msg)


proc do_anonsurf_changeid(cb_send_msg: proc) {.gcsafe.} =
  ansurf_acts_handle_changeID(cb_send_msg)


proc do_anonsurf_checkip(cb_send_msg: proc) {.gcsafe.} =
  ansurf_acts_handle_checkIP(cb_send_msg)


proc ansurf_gtk_do_start_stop*(b: Button, cb_send_msg: proc) =
  if b.label == "Start":
    # cb_kill_apps(cb_send_msg)
    dialog_kill_app(cb_send_msg)
    # ansurf_acts_handle_start("menuexecg", cb_send_msg)
    createThread(ansurf_workers_common, do_anonsurf_start, cb_send_msg)
  else:
    # createThread(ansurf_workers_common, do_anonsurf_stop, cb_send_msg)
    ansurf_acts_handle_stop("menuexecg", cb_send_msg)
    if not getServStatus("anonsurfd"):
      dialog_kill_app(cb_send_msg)
  # joinThread(ansurf_workers_common)


proc ansurf_gtk_do_restart*(b: Button, cb_send_msg: proc) =
  createThread(ansurf_workers_common, do_anonsurf_restart, cb_send_msg)
  # ansurf_workers_common.joinThread()


proc ansurf_gtk_do_myip*(b: Button | MenuItem, cb_send_msg: proc) =
  createThread(ansurf_workers_myip, do_anonsurf_checkip, (cb_send_msg))
  # ansurf_workers_myip.joinThread()
  # do_anonsurf_checkip(cb_send_msg)


proc ansurf_gtk_do_changeid*(b: Button, cb_send_msg: proc) =
  createThread(ansurf_workers_common, do_anonsurf_changeid, (cb_send_msg))
  ansurf_workers_common.joinThread()


proc ansurf_gtk_do_status*(b: Button) =
  onClickTorStatus()
