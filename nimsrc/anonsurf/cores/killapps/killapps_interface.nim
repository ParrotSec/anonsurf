# import osproc
import os
import gintro / [gtk, gobject]
import killapps_commands


proc onExit*(w: Window) =
  mainQuit()


proc cmd_kill_apps*(callback_send_messages: proc) =
  const
    path_bleachbit = "/usr/bin/bleachbit"
  
  let kill_result = an_kill_apps()
  if kill_result != 0:
    callback_send_messages("Kill apps", "Some apps coudn't be killed", 1)
  
  if not fileExists(path_bleachbit):
    callback_send_messages("Kill apps", "Bleachbit is not found. Can't remove caches", 1)
  else:
    discard


proc cli_kill_apps*(msg_callback: proc) =
  while true:
    echo("[?] Do you want to kill dangerous applications? (Y/n)")
    let input = readLine(stdin)
    if input == "y" or input == "Y":
      if an_kill_apps() == 0:
        msg_callback("Apps killer", "Success", 0)
      else:
        msg_callback("Apps killer", "Error while killing apps", 1)
    elif input == "n" or input == "N":
      return
    else:
      msg_callback("Apps killer", "Invalid option! Please use Y / N", 1)


proc do_skip(b: Button) =
  discard


proc do_kill(b: Button, callback_send_msg: proc) =
  cmd_kill_apps(callback_send_msg)


proc do_exit(b: Button) =
  discard


proc box_kill_app*(callback_send_msg: proc): Box =
  let
    boxAppKill = newBox(Orientation.horizontal, 3)
    labelAsk = newLabel("Do you want to kill apps and clear cache?")
    boxButtons = newBox(Orientation.vertical, 3)
    btnKill = newButton("Kill")
    btnDoNotKill = newButton("Don't kill")
    btnCancel = newButton("Cancel")
  
  btnKill.connect("clicked", do_kill, callback_send_msg)
  boxButtons.add(btnKill)

  btnDoNotKill.connect("clicked", do_skip)
  boxButtons.add(btnDoNotKill)

  btnCancel.connect("clicked", do_exit)
  boxButtons.add(btnCancel)

  boxAppKill.add(labelAsk)
  boxAppkill.add(boxButtons)
  return boxAppKill


proc window_kill_app*(callback_send_msg: proc): Window =
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
  mainBoard.connect("destroy", onExit)
  gtk.main()