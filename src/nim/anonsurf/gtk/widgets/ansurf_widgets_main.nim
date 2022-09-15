import gintro / [gtk, glib, gobject]
import gintro / gdk except Window
import .. / gui_activities / [core_activities, widget_main]
import .. / .. / cores / commons / ansurf_objects


proc ansurf_main_w_detail_area*(imgStatus: Image, labDetails: Label, btnStatus, btnRestart: Button, s: Stack, cb_send_msg: callback_send_messenger): Frame =
  #[
    Create the area Detail in main page
    it has image of current AnonSurf
    Button details which switch to details
    Button status which show nyx
  ]#
  let
    fmDetail = newFrame() # The outsider. Use it to make border
    areaInfo = newBox(Orientation.vertical, 3) # Whole left widget, vertical
    bxButtons = newBox(Orientation.horizontal, 3) # Only buttons. This's used for horizontal buttons
    bxDetailPanel = newBox(Orientation.horizontal, 6) # This is the whole box, horizontal
    evBox = gtk.newEventBox()

  btnRestart.connect("clicked", ansurf_gtk_do_restart, cb_send_msg)
  btnStatus.connect("clicked", ansurf_gtk_do_status)

  bxButtons.packStart(btnRestart, false, true, 4)
  bxButtons.packStart(btnStatus, false, true, 2)

  bxDetailPanel.add(imgStatus)

  evBox.connect("button-press-event", ansurf_gtk_widget_show_details, s)

  areaInfo.packStart(labDetails, false, true, 3)
  areaInfo.packEnd(bxButtons, false, true, 5)

  evBox.add(areaInfo)
  bxDetailPanel.add(evBox)

  fmDetail.add(bxDetailPanel)
  return fmDetail


proc ansurf_main_w_button_area*(btnStart, btnChangeID, btnCheckIP: Button, cb_send_msg: callback_send_messenger): Frame =
  #[
    Create Tool Panel which has buttons
  ]#
  let
    boxTool = newBox(Orientation.horizontal, 6)
    fmTool = newFrame()

  btnStart.connect("clicked", ansurf_gtk_do_start_stop, cb_send_msg)
  btnChangeID.connect("clicked", ansurf_gtk_do_changeid, cb_send_msg)
  btnCheckIP.connect("clicked", ansurf_gtk_do_myip, cb_send_msg)
  btnStart.setSizeRequest(80, 80)
  btnChangeID.setSizeRequest(80, 80)
  btnCheckIP.setSizeRequest(80, 80)

  boxTool.add(btnStart)
  boxTool.add(btnChangeID)
  boxTool.add(btnCheckIP)

  fmTool.add(boxTool)

  return fmTool


proc ansurf_main_w_main_area*(box_detail_area, box_button_area: Frame): Box =
  #[
    Create the page for main widget
  ]#
  let
    mainWidget = newBox(Orientation.vertical, 3)

  mainWidget.packStart(box_detail_area, false, true, 2)
  mainWidget.packStart(box_button_area, false, true, 1)
  return mainWidget
