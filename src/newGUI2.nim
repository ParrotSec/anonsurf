import gintro / [gtk, glib, gobject]
import gui / displays / pages / [main, detail]
import gui / actions / [cores, toolbar, details, refresh]
import utils / status
# import system
# TODO best performance for refresh
# TODO threading for myip

type
  RefreshObj = ref object
    mainObjs: MainObjs
    detailObjs: DetailObjs
    stackObjs: Stack


proc handleRefresh(args: RefreshObj): bool =
  let freshStatus = getSurfStatus()

  if args.stackObjs.getVisibleChildName == "main":
    updateMain(args.mainObjs, freshStatus)
  else:
    updateDetail(args.detailObjs, freshStatus)

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
    labelDetails = newLabel("AnonSurf is not running")
    btnShowDetails = newButton("Details")
    btnShowStatus = newButton("Tor Stats")
    btnChangeID = newButton("Change\nIdentify")
    btnCheckIP = newButton("My IP")
    imgStatus = newImageFromIconName("security-medium", 6)
    mainWidget = createMainWidget(imgStatus, labelDetails, btnStart, btnShowDetails, btnShowStatus, btnChangeID, btnCheckIP)

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
  
  btnRestart.connect("clicked", onClickRestart)
  btnBoot.connect("clicked", onClickBoot)

  let
    mainStack = newStack()
  
  btnShowDetails.connect("clicked", onClickDetail, mainStack)
  btnBack.connect("clicked", onClickBack, mainStack)

  mainStack.addNamed(mainWidget, "main")
  mainStack.addNamed(detailWidget, "detail")
  boxMainWindow.add(mainStack)
  boxMainWindow.showAll()
  
  var
    mainArgs = MainObjs(
      btnRun: btnStart,
      btnID: btnChangeID,
      btnDetail: btnShowDetails,
      btnStatus: btnShowStatus,
      lDetails: labelDetails,
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
    refresher = RefreshObj(
      mainObjs: mainArgs,
      detailObjs: detailArgs,
      stackObjs: mainStack,
    )

  # Load latest status when start program
  let atStartStatus = getSurfStatus()
  updateMain(mainArgs, atStartStatus)
  updateDetail(detailArgs, atStartStatus)

  discard timeoutAdd(200, handleRefresh, refresher)


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
