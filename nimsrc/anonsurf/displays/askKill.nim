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


proc boxAskKillApps*(): Box =
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


proc initAskDialog*() =
  gtk.init()

  let
    mainBoard = newWindow()
    boxMainWindow = boxAskKillApps()
  
  mainBoard.setResizable(false)
  mainBoard.title = "Kill dangerous application"
  mainBoard.setPosition(WindowPosition.center)
  mainBoard.add(boxMainWindow)
  mainBoard.setBorderWidth(3)

  mainBoard.showAll()
  mainBoard.connect("destroy", onExit)
  gtk.main()
