import gintro / gtk
import .. / .. / cores / handle_activities
import .. / .. / cores / handle_killapps
import .. / ansurf_objects
import .. / widgets / tor_status_widget

let cb_kill_apps = init_gtk_askkill() 


proc do_anonsurf_start(cb_send_msg: proc) {.gcsafe.} =
  ansurf_acts_handle_start("gksudo", cb_kill_apps, cb_send_msg)


proc do_anonsurf_stop(cb_send_msg: proc) {.gcsafe.} =
  ansurf_acts_handle_stop("gksudo", cb_kill_apps, cb_send_msg)


proc do_anonsurf_restart(cb_send_msg: proc) {.gcsafe.} =
  ansurf_acts_handle_restart("gksudo", cb_send_msg)


proc do_anonsurf_changeid(cb_send_msg: proc) {.gcsafe.} =
  ansurf_acts_handle_changeID(cb_send_msg)


proc do_anonsurf_checkip(cb_send_msg: proc) {.gcsafe.} =
  ansurf_acts_handle_checkIP(cb_send_msg)


proc ansurf_gtk_do_start_stop*(b: Button, cb_send_msg: proc) =
  if b.label == "Start":
    # createThread(ansurf_workers_common, do_anonsurf_start, cb_send_msg)
    # createThread(ansurf_start_stop_workers, ansurf_acts_handle_start, ("gksudo", cb_kill_apps, cb_send_msg))
    ansurf_acts_handle_start("gksudo", cb_kill_apps, cb_send_msg)
  else:
    # createThread(ansurf_workers_common, do_anonsurf_stop, cb_send_msg)
    ansurf_acts_handle_stop("gksudo", cb_kill_apps, cb_send_msg)
    # createThread(ansurf_start_stop_workers, ansurf_acts_handle_stop, "gksudo", cb_kill_apps, cb_send_msg)
  # joinThread(ansurf_workers_common)


proc ansurf_gtk_do_restart*(b: Button, cb_send_msg: proc) =
  createThread(ansurf_workers_common, do_anonsurf_restart, cb_send_msg)
  # ansurf_workers_common.joinThread()
  # createThread(ansurf_workers_common_sudo, ansurf_acts_handle_restart, ("gksudo", cb_send_msg))
  # ansurf_acts_handle_restart("gksudo", cb_send_msg)


proc ansurf_gtk_do_myip*(b: Button, cb_send_msg: proc) =
  # ansurf_acts_handle_checkIP(cb_send_msg)
  createThread(ansurf_workers_myip, do_anonsurf_checkip, (cb_send_msg))


proc ansurf_gtk_do_changeid*(b: Button, cb_send_msg: proc) =
  # ansurf_acts_handle_changeID(cb_send_msg)
  createThread(ansurf_workers_common, do_anonsurf_changeid, (cb_send_msg))
  ansurf_workers_common.joinThread()


proc ansurf_gtk_do_status*(b: Button) =
  onClickTorStatus()
