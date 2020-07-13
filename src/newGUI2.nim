import gintro / [gtk, glib, gobject]
import gui / displays / pages / [main, detail]
import gui / actions / [cores, toolbar, details, refresh]
import utils / status
# import system
# TODO best performance for refresh
# TODO handle gksudo when click cancel
# TODO threading for myip


proc createDetailWidget(
  labelAnon, labelTor, labelDNS, labelBoot: Label,
  btnBoot, btnBack, btnRestart: Button,
  imgBoot: Image,
  ): Box =
  #[
    Create a page to display current detail of AnonSurf
  ]#
  let
    boxServices = makeServiceDetails(
      labelAnon, labelTor, labelDNS, labelBoot, btnBoot, btnRestart, imgBoot
    )
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


proc refreshDetail(args: DetailObjs): bool =
  let freshStatus = getSurfStatus()
  updateDetail(args, freshStatus)
  return SOURCE_CONTINUE


proc refreshMain(args: MainObjs): bool =
  #[
    Always check status of current widget
      to show correct state of buttons
  ]#
  let freshStatus = getSurfStatus()
  updateMain(args, freshStatus)
  
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
    imgStatus = newImageFromIconName("security-medium", 6)
    mainWidget = createMainWidget(imgStatus, btnStart, btnShowDetail, btnShowStatus, btnChangeID, btnCheckIP)

  btnStart.connect("clicked", onClickRun)
  btnCheckIP.connect("clicked", onClickCheckIP)
  btnChangeID.connect("clicked", onClickChangeID)
  btnShowStatus.connect("clicked", onClickTorStatus)

  let
    labelAnonDaemon = newLabel("Anon Daemon: Inactivated")
    labelTor = newLabel("Tor Daemon: Inactivated")
    labelDNS = newLabel("DNS: LocalHost")
    imgStatusBoot = newImageFromIconName("security-low", 6)
    labelStatusBoot = newLabel("Not enabled at boot")
    btnBoot = newButton("Enable")
    btnBack = newButton("Back")
    btnRestart = newButton("Restart")
    detailWidget = createDetailWidget(
      labelAnonDaemon, labelTor, labelDNS, labelStatusBoot,
      btnBoot, btnBack, btnRestart, imgStatusBoot
    )
  
  let
    mainStack = newStack()
  
  btnShowDetail.connect("clicked", onClickDetail, mainStack)
  btnBack.connect("clicked", onClickBack, mainStack)

  mainStack.addNamed(mainWidget, "main")
  mainStack.addNamed(detailWidget, "detail")
  boxMainWindow.add(mainStack)
  boxMainWindow.showAll()
  
  var
    mainArgs = MainObjs(
      btnRun: btnStart,
      btnID: btnChangeID,
      btnDetail: btnShowDetail,
      btnStatus: btnShowStatus,
      imgStatus: imgStatus,
    )
    detailArgs = DetailObjs(
      lblAnon: labelAnonDaemon,
      lblTor: labelTor,
      lblDns: labelDNS,
      lblBoot: labelStatusBoot,
      btnBoot: btnBoot,
      btnRestart: btnRestart,
      imgBoot: imgStatusBoot
    )

  # Load latest status when start program
  let atStartStatus = getSurfStatus()
  updateMain(mainArgs, atStartStatus)
  updateDetail(detailArgs, atStartStatus)

  # Do the refresh
  if mainStack.getVisibleChildName == "main":
    discard timeoutAdd(200, refreshMain, mainArgs)
  elif mainStack.getVisibleChildName == "detail": # Fix me can not refresh only 1 widget
    discard timeoutAdd(200, refreshDetail, detailArgs)

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
