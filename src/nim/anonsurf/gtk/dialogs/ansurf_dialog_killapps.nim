#[
  Create a dialog to ask user to kill applications.
  Call this inside AnonSurf GTK. No need to init new GTK app
]#

import gintro / [gtk, gobject]
import .. / .. / cores / commons / ansurf_objects
import .. / .. / cores / activities / kill_apps_actions
import .. / gui_activities / core_activities


type
  KillArgs = object
    cb_send_msg: callback_send_messenger
    d: Dialog


proc do_not_kill(b: Button, d: Dialog) =
  ansurf_gtk_close_dialog(d)


proc do_kill(b: Button, args: KillArgs) =
  ansurf_kill_apps(args.cb_send_msg)
  ansurf_gtk_close_dialog(args.d)


# proc do_exit(b: Button) =
#   mainQuit()
#   # TODO do not start anonsurf instead of just call


proc box_kill_app(callback_send_msg: callback_send_messenger, d: Dialog): Box =
  let
    boxAppKill = newBox(Orientation.vertical, 3)
    labelAsk = newLabel("Do you want to kill apps and clear cache?")
    boxButtons = newBox(Orientation.horizontal, 3)
    btnKill = newButton("Kill")
    btnDoNotKill = newButton("Don't kill")
    # btnCancel = newButton("Cancel")
    pass_args = KillArgs(
      cb_send_msg: callback_send_msg,
      d: d
    )

  btnKill.connect("clicked", do_kill, pass_args)
  boxButtons.add(btnKill)

  btnDoNotKill.connect("clicked", do_not_kill, d)
  boxButtons.packEnd(btnDoNotKill, false, true, 3)

  # btnCancel.connect("clicked", do_exit)
  # boxButtons.add(btnCancel)

  boxAppKill.add(labelAsk)
  boxAppkill.add(boxButtons)
  return boxAppKill


proc dialog_kill_apps*(callback_send_msg: callback_send_messenger) =
  let
    retDialog = newDialog()
    dialogArea = retDialog.getContentArea()
    boxDialog = box_kill_app(callback_send_msg, retDialog)
  retDialog.setTitle("Kill dangerous application")
  dialogArea.add(boxDialog)
  retDialog.showAll()
  discard retDialog.run()
  ansurf_gtk_close_dialog(retDialog)
