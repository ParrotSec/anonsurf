import gintro / [gtk, glib, gobject]#, notify, vte]


proc onClickAnonSurf(b: Button, s: Stack) =
  s.setVisibleChildName("anonsurf")


proc createArea(boxMainWindow: Box) =
  #[
    Draw the dashboard
  ]#
  let
    btnAnon = newButton("AnonSurf")
    btnBoot = newButton("Start at boot")
    btnExtra = newButton("Extra")
    boxMainButtons = newBox(Orientation.horizontal, 3)

  boxMainButtons.add(btnAnon)
  boxMainButtons.add(btnBoot)
  boxMainButtons.add(btnExtra)
  boxMainButtons.show()
  # End of draw dashboard

  #[
    Draw AnonSurf board
  ]#
  let
    btnStart = newButton("Start")
    btnStartBridge = newButton("Start Bridge")
    btnStop = newButton("Stop")
    btnBack = newButton("Back")
    boxAnonButtons = newBox(Orientation.horizontal, 3)

  boxAnonButtons.add(btnStart)
  boxAnonButtons.add(btnStartBridge)
  boxAnonButtons.add(btnStop)
  boxAnonButtons.add(btnBack)
  boxAnonButtons.show()
  # End of AnonSurf board
  
  let
    boxDashboard = newBox(Orientation.vertical, 3)
    mainStack = newstack()
  
  mainStack.addNamed(boxMainButtons, "main")
  mainStack.addNamed(boxAnonButtons, "anonsurf")
  mainStack.setVisibleChildName("main")

  btnAnon.connect("clicked", onClickAnonSurf, mainStack)


  boxMainWindow.add(mainStack)
  boxMainWindow.showAll()
  
  boxDashboard.showAll()

  boxMainWindow.add(boxDashboard)
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

  # mainBoard.showAll()
  mainBoard.show()
  mainBoard.connect("destroy", stop)
  gtk.main()

main()
