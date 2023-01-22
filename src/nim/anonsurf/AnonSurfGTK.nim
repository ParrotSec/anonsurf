import gintro / [gtk, glib, gobject, gio]
import gintro / gdk except Window
import cores / handle_activities
import gtk / widgets / [ansurf_widget_details, ansurf_widgets_main]
import gtk / [ansurf_icons, ansurf_gui_refresher, ansurf_title_bar, ansurf_systray, ansurf_gtk_objects]
# all widget activities must be declared here to fix macro error
import gtk / gui_activities / core_activities
import cores / commons / ansurf_objects


proc init_main_window(w: Window) =
  w.setResizable(false)
  w.setTitlebar(surfTitleBar())
  w.setIcon(surfIcon)
  w.setPosition(WindowPosition.center)
  w.setBorderWidth(3)
  w.connect("delete_event", ansurf_gtk_do_not_stop)


proc init_stack(b: Box, s: Stack, mainWidget, detailWidget: Box) =
  s.addNamed(mainWidget, "main")
  s.addNamed(detailWidget, "detail")
  b.add(s)


proc createWindowLayout(mainBoard: ApplicationWindow, cb_send_msg: callback_send_messenger): Box =
  #[
    Create everything for the program
  ]#
  let
    boxMainWindow = newBox(Orientation.vertical, 3)
    mainStack = newStack()
    btnStart = newButton("Start")
    labelDetails = newLabel("AnonSurf is not running")
    btnShowStatus = newButton("Tor Stats")
    btnChangeID = newButton("Change\nIdentity")
    btnCheckIP = newButton("My IP")
    btnRestart = newButton("Restart")
    imgStatus = newImageFromPixbuf(surfImages.imgSecMed)
    labelServices = newLabel("Services: Checking")
    labelPorts = newLabel("Ports: Checking")
    labelDNS = newLabel("DNS: Checking")
    imgBootStatus = newImageFromPixbuf(surfImages.imgBootOff)
    labelBootStatus = newLabel("Not enabled at boot")
    btnBoot = newButton("Enable")

    mainWidget = ansurf_main_w_main_area(
      ansurf_main_w_detail_area(imgStatus, labelDetails, btnShowStatus, btnRestart, mainStack, cb_send_msg),
      ansurf_main_w_button_area(btnStart, btnChangeID, btnCheckIP, cb_send_msg)
    )
    detailWidget = ansurf_details_w_main_area(
      ansurf_detail_w_service_area(labelServices, labelPorts, labelDNS, mainStack),
      ansurf_detail_w_boot_area(labelBootStatus, btnBoot, imgBootStatus, cb_send_msg)
    )
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

  init_stack(boxMainWindow, mainStack, mainWidget, detailWidget)

  # Load latest status when start program. Useful when start AnonSurf GUI again (after it ran)
  ansurf_handle_refresh_all(refreshObjects)
  discard timeoutAdd(200, ansurf_handle_refresh_layouts, refreshObjects)

  return boxMainWindow


proc anonsurf_app(app: Application, sysTrayIcon: StatusIcon) =
  let
    w = newApplicationWindow(app)
    cb_send_msg = cli_init_callback_msg(true)

  sysTrayIcon.connect("activate", ansurf_left_click, w)
  sysTrayIcon.connect("popup-menu", ansurf_right_click_menu, cb_send_msg)

  w.init_main_window()
  w.add(createWindowLayout(w, cb_send_msg))
  w.showAll()


proc main =
  let
    sysTrayIcon = newStatusIconFromPixbuf(surfIcon)
    app = newApplication("org.parrot.anonsurf-gtk")

  app.connect("activate", anonsurf_app, sysTrayIcon)
  discard app.run()


gtk.init()
ansurf_gtk_start_daemon()
main()
