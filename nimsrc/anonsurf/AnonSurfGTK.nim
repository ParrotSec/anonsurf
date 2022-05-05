import gintro / [gtk, glib, gobject]
import cores / handle_activities
import gtk / widgets / [details_widget, ansurf_widgets_main]
import gtk / [ansurf_icons, ansurf_gui_refresher, ansurf_title_bar, ansurf_get_status, ansurf_systray, ansurf_gtk_objects]
# all widget activities must be declared here to fix macro error
import gtk / gui_activities / [details_widget_activities, core_activities, main_widget_activities]
import gintro / gdk except Window


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
    mainStack = newStack()

  let
    btnStart = newButton("Start")
    labelDetails = newLabel("AnonSurf is not running")
    btnShowStatus = newButton("Tor Stats")
    btnChangeID = newButton("Change\nIdentity")
    btnCheckIP = newButton("My IP")
    btnRestart = newButton("Restart")
    imgStatus = newImageFromPixbuf(surfImages.imgSecMed)
    mainWidget = ansurf_main_w_main_area(
      ansurf_main_w_detail_area(imgStatus, labelDetails, btnShowStatus, btnRestart, mainStack, cb_send_msg),
      ansurf_main_w_button_area(btnStart, btnChangeID, btnCheckIP, cb_send_msg)
    )


  let
    labelDaemons = newLabel("Services: Checking")
    labelPorts = newLabel("Ports: Checking")
    labelDNS = newLabel("DNS: Checking")
    imgStatusBoot = newImageFromPixbuf(surfImages.imgBootOff)
    labelStatusBoot = newLabel("Not enabled at boot")
    btnBoot = newButton("Enable")
    detailWidget = createDetailWidget(
      labelDaemons, labelPorts, labelDNS, labelStatusBoot,
      btnBoot, imgStatusBoot, mainStack
    )

  btnBoot.connect("clicked", ansurf_gtk_do_enable_disable_boot, cb_send_msg)

  mainStack.addNamed(mainWidget, "main")
  mainStack.addNamed(detailWidget, "detail")
  boxMainWindow.add(mainStack)

  boxMainWindow.showAll()

  var
    mainArgs = MainObjs(
      btnRun: btnStart,
      btnID: btnChangeID,
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
    sysTrayIcon = newStatusIconFromPixbuf(surfIcon)

  mainBoard.setResizable(false)
  mainBoard.setTitlebar(surfTitleBar())
  mainBoard.setIcon(surfIcon)
  mainBoard.setPosition(WindowPosition.center)

  sysTrayIcon.connect("popup-menu", ansurf_right_click_menu)
  sysTrayIcon.connect("activate", ansurf_left_click, mainBoard)

  createArea(boxMainWindow)

  mainBoard.add(boxMainWindow)
  mainBoard.setBorderWidth(3)
  mainBoard.connect("delete_event", ansurf_gtk_do_not_stop)

  mainBoard.showAll()
  gtk.main()

main()
