import gintro / [gtk, glib, gobject]
import gui / display / [widgets, details]
import gui / actions / [cores, toolbar]


proc createDetailWidget(labelDNS: Label, btnBack: Button): Box =
  #[
    Create a page to display current detail of AnonSurf
  ]#
  let
    boxServices = makeServiceDetails(labelDNS)
    boxDetailWidget = newBox(Orientation.vertical, 3)
    boxBottomBar = makeBottomBarForDetail(btnBack)
  
  boxDetailWidget.add(boxServices)
  boxDetailWidget.packEnd(boxBottomBar, false, true, 3)
  return boxDetailWidget


proc createMainWidget(labelTest: Label, bStart, bDetail, bStatus, bID, bIP: Button): Box =
  #[
    Create the page for main widget
  ]#
  let
    boxPanel = makeDetailPanel(labelTest, bDetail, bStatus)
    boxToolBar = makeToolBar(bStart, bID, bIP)
    bottomBar = makeBottomBarForMain()
    mainWidget = newBox(Orientation.vertical, 3)
  
  mainWidget.add(boxPanel)
  mainWidget.add(boxToolBar)
  mainWidget.packEnd(bottomBar, false, true, 3)
  return mainWidget


proc refreshStatus(): bool =
  return SOURCE_CONTINUE


proc createArea(boxMainWindow: Box) =
  #[
    Create everything for the program
  ]#
  let
    labelTest = newLabel("Not running")
    btnStart = newButton("Start")
    btnDetail = newButton("AnonSurf is not running")
    btnStatus = newButton("Monitor shit")
    btnChangeID = newButton("Change ID")
    btnCheckIP = newButton("My IP")

    labelDNS = newLabel("Localhost")

  btnCheckIP.connect("clicked", onClickCheckIP)
  let btnBack = newButton("Back")
  
  let
    mainStack = newStack()
    mainWidget = createMainWidget(labelTest, btnStart, btnDetail, btnStatus, btnChangeID, btnCheckIP)
    detailWidget = createDetailWidget(labelDNS, btnBack)
  
  btnDetail.connect("clicked", onClickDetail, mainStack)
  btnBack.connect("clicked", onClickBack, mainStack)

  mainStack.addNamed(mainWidget, "main")
  mainStack.addNamed(detailWidget, "detail")
  boxMainWindow.add(mainStack)
  boxMainWindow.showAll()


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
  mainBoard.connect("destroy", onClickStop)
  gtk.main()

main()
