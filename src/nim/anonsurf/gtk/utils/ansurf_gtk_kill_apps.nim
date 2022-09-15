#[
  Init new GTK application to ask user to kill apps
  Call when function is not inside AnonSurf GTK
]#

import gintro / [gtk, gobject]
import .. / .. / cores / commons / ansurf_objects
import .. / .. / cores / activities / kill_apps_actions


proc onClickExit(w: Window) =
  mainQuit()


proc do_not_kill(b: Button) =
  mainQuit()


proc do_kill(b: Button, callback_send_msg: callback_send_messenger) =
  ansurf_kill_apps(callback_send_msg)
  mainQuit()


# proc do_exit(b: Button) =
#   mainQuit()
#   # TODO do not start anonsurf instead of just call


proc box_kill_app(callback_send_msg: callback_send_messenger): Box =
  let
    boxAppKill = newBox(Orientation.vertical, 3)
    labelAsk = newLabel("Do you want to kill apps and clear cache?")
    boxButtons = newBox(Orientation.horizontal, 3)
    btnKill = newButton("Kill")
    btnDoNotKill = newButton("Don't kill")
    # btnCancel = newButton("Cancel")
  
  btnKill.connect("clicked", do_kill, callback_send_msg)
  boxButtons.add(btnKill)

  btnDoNotKill.connect("clicked", do_not_kill)
  boxButtons.packEnd(btnDoNotKill, false, true, 3)

  # btnCancel.connect("clicked", do_exit)
  # boxButtons.add(btnCancel)

  boxAppKill.add(labelAsk)
  boxAppkill.add(boxButtons)
  return boxAppKill


proc window_kill_app*(callback_send_msg: callback_send_messenger) =
  gtk.init()
  let
    mainBoard = newWindow()
    boxMainWindow = box_kill_app(callback_send_msg)
  
  mainBoard.setResizable(false)
  mainBoard.title = "Kill dangerous application"
  mainBoard.setPosition(WindowPosition.center)
  mainBoard.add(boxMainWindow)
  mainBoard.setBorderWidth(3)

  mainBoard.showAll()
  mainBoard.connect("destroy", onClickExit)
  gtk.main()
