import gintro / gtk
import .. / .. / cores / handle_activities
import .. / ansurf_gtk_objects
import .. / .. / cores / commons / ansurf_objects


proc do_anonsurf_enable_boot(cb_send_msg: callback_send_messenger) {.gcsafe.} =
  ansurf_acts_handle_boot_enable("menuexecg", cb_send_msg)


proc do_anonsurf_disable_boot(cb_send_msg: callback_send_messenger) {.gcsafe.} =
  ansurf_acts_handle_boot_disable("menuexecg", cb_send_msg)


proc ansurf_gtk_do_enable_disable_boot*(b: Button, cb_send_msg: callback_send_messenger) =
  if b.label == "Enable":
    createThread(ansurf_workers_common, do_anonsurf_enable_boot, cb_send_msg)
  else:
    createThread(ansurf_workers_common, do_anonsurf_disable_boot, cb_send_msg)

  ansurf_workers_common.joinThread()
