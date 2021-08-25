import gintro / gtk
import .. / .. / cores / handle_activities


proc ansurf_gtk_do_enable_disable_boot*(b: Button, cb_send_msg: proc) =
  if b.label == "Enable":
    ansurf_acts_handle_boot_enable(cb_send_msg)
  else:
    ansurf_acts_handle_boot_disable(cb_send_msg)
