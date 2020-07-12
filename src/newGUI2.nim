import gintro / [gtk, glib, gobject]
# import gintro / gdk
import gui / display / [widgets, details]
import gui / actions / [cores, toolbar]
import utils / status
# import system
# TODO first check status all then do check again if file changed
# save performance

type
  RefreshObj = ref object
    btnRun: Button
    btnID: Button
    btnDetail: Button
    btnStatus: Button
    imgStatus: Image


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


proc createMainWidget(imgStatus: Image, bStart, bDetail, bStatus, bID, bIP: Button): Box =
  #[
    Create the page for main widget
  ]#
  let
    boxPanel = makeDetailPanel(imgStatus, bDetail, bStatus)
    boxToolBar = makeToolBar(bStart, bID, bIP)
    bottomBar = makeBottomBarForMain()
    mainWidget = newBox(Orientation.vertical, 3)
  
  mainWidget.add(boxPanel)
  mainWidget.add(boxToolBar)
  mainWidget.packEnd(bottomBar, false, true, 3)
  return mainWidget


proc refreshStatus(args: RefreshObj): bool =
  #[
    Always check status of current widget
      to show correct state of buttons
  ]#
  if getStatusService("anonsurfd") == 1:
    args.btnRun.label = "Stop"
    args.btnID.setSensitive(true)
    args.btnDetail.label= "AnonSurf is running"
    args.btnStatus.setSensitive(true)
    # args.imgStatus.setFromIconName("security-high", 64) # TODO check actual status
  else:
    args.btnRun.label = "Start"
    args.btnID.setSensitive(false)
    args.btnDetail.label= "AnonSurf is not running"
    args.btnStatus.setSensitive(false)
    # args.imgStatus.setFromIconName("security-medium", 64) # TODO check actual status
  
  return SOURCE_CONTINUE


proc createArea(boxMainWindow: Box) =
  #[
    Create everything for the program
  ]#
  # const
  #   imgAnonFail = staticRead("../icons/50px/anon_50px_failed.png")
  #   imgAnonProtected = staticRead("../icons/50px/anon_50px_protected.png")
  #   imgAnonUnprotected = staticRead("../icons/50px/anon_50px_unprotected.png")

  let
    btnStart = newButton("Start")
    btnShowDetail = newButton("AnonSurf is not running")
    btnShowStatus = newButton("Show Tor information")
    btnChangeID = newButton("Change\nIdentify")
    btnCheckIP = newButton("My IP")

    labelDNS = newLabel("Localhost")
    imgStatus = newImageFromIconName("security-medium", 64) #FIXME gtk-warning invalid icon size

  btnShowDetail.setSizeRequest(80, 30)
  btnShowStatus.setSizeRequest(80, 30)
  btnCheckIP.connect("clicked", onClickCheckIP)
  let btnBack = newButton("Back")
  
  let
    mainStack = newStack()
    mainWidget = createMainWidget(imgStatus, btnStart, btnShowDetail, btnShowStatus, btnChangeID, btnCheckIP)
    detailWidget = createDetailWidget(labelDNS, btnBack)
  
  btnShowDetail.connect("clicked", onClickDetail, mainStack)
  btnBack.connect("clicked", onClickBack, mainStack)

  mainStack.addNamed(mainWidget, "main")
  mainStack.addNamed(detailWidget, "detail")
  boxMainWindow.add(mainStack)
  boxMainWindow.showAll()
  
  var args = RefreshObj(
    btnRun: btnStart,
    btnID: btnChangeID,
    btnDetail: btnShowDetail,
    btnStatus: btnShowStatus,
    imgStatus: imgStatus,
  )
  discard timeoutAdd(200, refreshStatus, args)


proc main =
  #[
    Create new window
    http://blog.borovsak.si/2009/06/multi-threaded-gtk-applications.html
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
