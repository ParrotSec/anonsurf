import gintro / [gtk, glib, gobject]


proc createArea(boxMainWindow: Box) =
  let
    widgetStatus = newBox(Orientation.horizontal, 3)
    # TODO image
    tmpLabel = newLabel("Nothing here")
    boxStatusButtons = newBox(Orientation.vertical, 3)
    btnDetails = newButton("AnonSurf is running")
    btnStatus = newButton("Show status") # call nyx
  
  widgetStatus.add(tmpLabel)

  boxStatusButtons.add(btnDetails)
  boxStatusButtons.add(btnStatus)

  widgetStatus.add(boxStatusButtons)

  boxMainWindow.add(widgetStatus)

  let
    widgetToolbar = newBox(Orientation.horizontal, 3)
    btnStart = newButton("Start")
    btnChangeID = newButton("Change ID")
    btnMyIP = newButton("My IP")
  
  widgetToolbar.add(btnStart)
  btnStart.setSizeRequest(80, 80)
  widgetToolbar.add(btnChangeID)
  btnChangeID.setSizeRequest(80, 80)
  widgetToolbar.add(btnMyIP)
  btnMyIp.setSizeRequest(80, 80)

  boxMainWindow.add(widgetToolBar)

  let
    bottomBar = newBox(Orientation.horizontal, 3)
    btnAbout = newButton("About")
    btnExit = newButton("Exit")
  
  bottomBar.add(btnAbout)
  bottomBar.add(btnExit)

  boxMainWindow.add(bottomBar)

  boxMainWindow.showAll()

proc stop(w: Window) =
  mainQuit()


proc main =
  #[
    Create new window
  ]#
  gtk.init()
  let
    mainBoard = newWindow()
    boxMainWindow = newBox(Orientation.vertical, 3)
  
  mainBoard.title = "AnonSurf GUI"
  discard mainBoard.setIconFromFile("/usr/share/icons/anonsurf.png")

  createArea(boxMainWindow)

  mainBoard.add(boxMainWindow)
  mainBoard.setBorderWidth(3)

  mainBoard.show()
  mainBoard.connect("destroy", stop)
  gtk.main()

main()
