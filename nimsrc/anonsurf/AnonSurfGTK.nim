import gintro / [gtk, glib, gobject]
import cores / handle_activities
import gtk / widgets / [details_widget, main_widget, bottom_widget]
import gtk / [ansurf_icons, ansurf_gui_refresher, ansurf_systray]
import gtk / gui_activities / [details_widget_activities, main_widget_activities, core_activities]
import cores / handle_activities
import gtk / [ansurf_get_status, ansurf_objects]


proc handleRefresh(args: RefreshObj): bool =
  #[
    Program is having 2 pages: main and detail
    This handleRefresh check which page is using
    so it update only 1 page for better performance
  ]#
  let
    freshStatus = getSurfStatus()

  if args.stackObjs.getVisibleChildName == "main":
    updateMain(args.mainObjs, freshStatus)
  else:
    updateDetail(args.detailObjs, freshStatus)

  return SOURCE_CONTINUE


proc createArea(boxMainWindow: Box) =
  #[
    Create everything for the program
  ]#
  let
    cb_send_msg = cli_init_callback_msg(true)

  let
    btnStart = newButton("Start")
    labelDetails = newLabel("AnonSurf is not running")
    btnShowDetails = newButton("Details")
    btnShowStatus = newButton("Tor Stats")
    btnChangeID = newButton("Change\nIdentity")
    btnCheckIP = newButton("My IP")
    btnRestart = newButton("Restart")
    imgStatus = newImageFromPixbuf(surfImages.imgSecMed)
    mainWidget = createMainWidget(imgStatus, labelDetails, btnStart, btnShowStatus, btnChangeID, btnCheckIP, btnRestart)

  btnRestart.connect("clicked", ansurf_gtk_do_restart, cb_send_msg)
  btnShowStatus.connect("clicked", ansurf_gtk_do_status)
  btnStart.connect("clicked", ansurf_gtk_do_start_stop, cb_send_msg)
  btnChangeID.connect("clicked", ansurf_gtk_do_changeid, cb_send_msg)
  btnCheckIP.connect("clicked", ansurf_gtk_do_myip, cb_send_msg)

  let
    labelDaemons = newLabel("Services: Checking")
    labelPorts = newLabel("Ports: Checking")
    labelDNS = newLabel("DNS: Checking")
    imgStatusBoot = newImageFromPixbuf(surfImages.imgBootOff)
    labelStatusBoot = newLabel("Not enabled at boot")
    btnBoot = newButton("Enable")
    detailWidget = createDetailWidget(
      labelDaemons, labelPorts, labelDNS, labelStatusBoot,
      btnBoot, imgStatusBoot
    )
  
  btnBoot.connect("clicked", ansurf_gtk_do_enable_disable_boot, cb_send_msg)

  let
    mainStack = newStack()
  
  btnShowDetails.connect("clicked", ansurf_gtk_do_show_details, mainStack)

  mainStack.addNamed(mainWidget, "main")
  mainStack.addNamed(detailWidget, "detail")
  boxMainWindow.add(mainStack)

  let boxBottom = makeBottomBar(btnShowDetails)
  boxMainWindow.add(boxBottom)

  boxMainWindow.showAll()
  
  var
    mainArgs = MainObjs(
      btnRun: btnStart,
      btnID: btnChangeID,
      btnDetail: btnShowDetails,
      btnStatus: btnShowStatus,
      btnIP: btnCheckIP,
      lDetails: labelDetails,
      btnRestart: btnRestart,
      imgStatus: imgStatus,
    )
    detailArgs = DetailObjs(
      lblServices: labelDaemons,
      lblPorts: labelPorts,
      lblDns: labelDNS,
      lblBoot: labelStatusBoot,
      btnBoot: btnBoot,
      imgBoot: imgStatusBoot
    )
    refresher = RefreshObj(
      mainObjs: mainArgs,
      detailObjs: detailArgs,
      stackObjs: mainStack,
    )

  # Load latest status when start program
  let
    atStartStatus = getSurfStatus()
    # atStartPorts = getStatusPorts()
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
    sysTrayIcon = newStatusIcon()
  
  mainBoard.setResizable(false)
  mainBoard.title = "AnonSurf GUI"
  mainBoard.setIcon(surfIcon)
  mainBoard.setPosition(WindowPosition.center)

  sysTrayIcon.setFromPixbuf(surfIcon)
  sysTrayIcon.connect("popup-menu", ansurf_right_click_menu)

  createArea(boxMainWindow)

  mainBoard.add(boxMainWindow)
  mainBoard.setBorderWidth(3)

  mainBoard.show()
  mainBoard.connect("destroy", ansurf_gtk_do_stop)
  gtk.main()

main()
