import gintro / [gtk, glib, gobject]
import cores / handle_activities
import gtk / widgets / [ansurf_widget_details, ansurf_widgets_main]
import gtk / [ansurf_icons, ansurf_gui_refresher, ansurf_title_bar, ansurf_systray, ansurf_gtk_objects]
# all widget activities must be declared here to fix macro error
import gtk / gui_activities / [details_widget_activities, core_activities, main_widget_activities]
import gintro / gdk except Window


proc createWindowLayout(mainBoard: Window, sysTrayIcon: StatusIcon): Box =
  #[
    Create everything for the program
  ]#
  let
    cb_send_msg = cli_init_callback_msg(true)
    boxMainWindow = newBox(Orientation.vertical, 3)
    mainStack = newStack()
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
    labelServices = newLabel("Services: Checking")
    labelPorts = newLabel("Ports: Checking")
    labelDNS = newLabel("DNS: Checking")
    imgBootStatus = newImageFromPixbuf(surfImages.imgBootOff)
    labelBootStatus = newLabel("Not enabled at boot")
    btnBoot = newButton("Enable")
    detailWidget = ansurf_details_w_main_area(
      ansurf_detail_w_service_area(labelServices, labelPorts, labelDNS, mainStack),
      ansurf_detail_w_boot_area(labelBootStatus, btnBoot, imgBootStatus, cb_send_msg)
    )
  sysTrayIcon.connect("popup-menu", ansurf_right_click_menu, cb_send_msg)
  mainStack.addNamed(mainWidget, "main")
  mainStack.addNamed(detailWidget, "detail")
  boxMainWindow.add(mainStack)

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
      lblServices: labelServices,
      lblPorts: labelPorts,
      lblDns: labelDNS,
      lblBoot: labelBootStatus,
      btnBoot: btnBoot,
      imgBoot: imgBootStatus
    )
    refreshObjects = RefreshObj(
      mainObjs: mainArgs,
      detailObjs: detailArgs,
      stackObjs: mainStack,
    )

  # Load latest status when start program. Useful when start AnonSurf GUI again (after it ran)
  ansurf_handle_refresh_all(refreshObjects)

  discard timeoutAdd(200, ansurf_handle_refresh_layouts, refreshObjects)
  return boxMainWindow


proc init_main_window(w: Window) =
  w.setResizable(false)
  w.setTitlebar(surfTitleBar())
  w.setIcon(surfIcon)
  w.setPosition(WindowPosition.center)
  w.setBorderWidth(3)
  w.connect("delete_event", ansurf_gtk_do_not_stop)


proc main =
  #[
    Create new window
    http://blog.borovsak.si/2009/06/multi-threaded-gtk-applications.html
  ]#
  gtk.init()

  let
    mainBoard = newWindow()
    sysTrayIcon = newStatusIconFromPixbuf(surfIcon)

  sysTrayIcon.connect("activate", ansurf_left_click, mainBoard)
  init_main_window(mainBoard)
  mainBoard.add(createWindowLayout(mainBoard, sysTrayIcon))

  mainBoard.showAll()
  gtk.main()

main()
