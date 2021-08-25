import gintro / gtk
import .. / .. / cores / handle_activities


proc ansurf_gtk_do_start_stop*(b: Button, cb_kill_apps, cb_send_msg: proc) =
  if b.label == "Start":
    ansurf_acts_handle_start("gksudo", cb_kill_apps, cb_send_msg)
  else:
    ansurf_acts_handle_stop("gksudo", cb_kill_apps, cb_send_msg)


proc ansurf_gtk_do_restart*(b: Button, cb_send_msg: proc) =
  ansurf_acts_handle_restart("gksudo", cb_send_msg)


proc ansurf_gtk_do_myip*(b: Button, cb_send_msg: proc) =
  ansurf_acts_handle_checkIP(cb_send_msg)


proc ansurf_gtk_do_changeid*(b: Button, cb_send_msg: proc) =
  ansurf_acts_handle_changeID(cb_send_msg)


proc ansurf_gtk_do_status*() =
  echo "status (in development)"
