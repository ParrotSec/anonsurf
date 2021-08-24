import gintro / [gtk, gobject]
import noti
import .. / modules / cleaner


proc onExit*(w: Window) =
  mainQuit()


proc onClickYes(b: Button) =
  let killResult = doKillApp()
  if killResult == 0:
    sendNotify("AnonSurf", "Killed dangerous application", "security-high")
  elif killResult != -1:
    sendNotify("AnonSurf", "Error while trying to kill applications", "security-medium")
  mainQuit()


proc onClickNo(b: Button) =
  mainQuit()


proc onClickYesGtk(b: Button, d: Dialog) =
  let killResult = doKillApp()
  if killResult == 0:
    sendNotify("AnonSurf", "Killed dangerous application", "security-high")
  elif killResult != -1:
    sendNotify("AnonSurf", "Error while trying to kill applications", "security-medium")
  d.destroy()


proc onClickNoGtk(b: Button, d: Dialog) =
  d.destroy()


proc boxAskKillAppsCli(): Box =
  let
    retBox = newBox(Orientation.vertical, 3)
    boxButtons = newBox(Orientation.horizontal, 3)
    labelAsk = newLabel("Do you want to kill dangerous applications?")
    btnYes = newButton("Yes")
    btnNo = newButton("No")
  btnYes.connect("clicked", onClickYes)
  btnNo.connect("clicked", onClickNo)
  boxButtons.packEnd(btnYes, false, true, 3)
  boxButtons.packEnd(btnNo, false, true, 3)
  retBox.add(labelAsk)
  retBox.add(boxButtons)
  return retBox


proc initAskCli*() =
  gtk.init()
  let
    mainBoard = newWindow()
    boxMainWindow = boxAskKillAppsCli()
  
  mainBoard.setResizable(false)
  mainBoard.title = "Kill dangerous application"
  mainBoard.setPosition(WindowPosition.center)
  mainBoard.add(boxMainWindow)
  mainBoard.setBorderWidth(3)
  mainBoard.setTitle("Data cleaner")

  mainBoard.showAll()
  mainBoard.connect("destroy", onExit)
  gtk.main()


proc boxAskKillAppsGtk(d: Dialog): Box =
  let
    retBox = newBox(Orientation.vertical, 3)
    boxButtons = newBox(Orientation.horizontal, 3)
    labelAsk = newLabel("Do you want to kill dangerous applications?")
    btnYes = newButton("Yes")
    btnNo = newButton("No")
  btnYes.connect("clicked", onClickYesGtk, d)
  btnNo.connect("clicked", onClickNoGtk, d)
  boxButtons.packEnd(btnYes, false, true, 3)
  boxButtons.packEnd(btnNo, false, true, 3)
  retBox.add(labelAsk)
  retBox.add(boxButtons)
  return retBox


proc initAskDialog*() =
  let
    retDialog = newDialog()
    dialogArea = retDialog.getContentArea()
    boxDialog = boxAskKillAppsGtk(retDialog)
  retDialog.setTitle("Data cleaner")
  dialogArea.add(boxDialog)
  retDialog.showAll()
  discard retDialog.run()
  retDialog.destroy()
