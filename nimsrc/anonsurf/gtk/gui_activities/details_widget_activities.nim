import gintro / gtk
import .. / .. / cores / handle_activities
import .. / ansurf_objects


proc do_anonsurf_enable_boot(cb_send_msg: proc) {.gcsafe.} =
  ansurf_acts_handle_boot_enable("menuexec", cb_send_msg)


proc do_anonsurf_disable_boot(cb_send_msg: proc) {.gcsafe.} =
  ansurf_acts_handle_boot_disable("menuexec", cb_send_msg)


proc ansurf_gtk_do_enable_disable_boot*(b: Button, cb_send_msg: proc) =
  if b.label == "Enable":
    # ansurf_acts_handle_boot_enable("menuexec", cb_send_msg)
    createThread(ansurf_workers_common, do_anonsurf_enable_boot, cb_send_msg)
  else:
    # ansurf_acts_handle_boot_disable("menuexec", cb_send_msg)
    createThread(ansurf_workers_common, do_anonsurf_disable_boot, cb_send_msg)

  ansurf_workers_common.joinThread()
