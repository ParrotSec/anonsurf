import gintro / [gtk, gdk, gobject, glib]
import .. / gui_activities / core_activities


proc makeDetailPanel(imgStatus: Image, labDetails: Label, btnStatus, btnRestart: Button, s: Stack): Frame =
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

  bxButtons.packStart(btnRestart, false, true, 4)
  bxButtons.packStart(btnStatus, false, true, 2)

  bxDetailPanel.add(imgStatus)

  evBox.connect("button-press-event", ansurf_gtk_widget_details, s)

  areaInfo.packStart(labDetails, false, true, 3)
  areaInfo.packEnd(bxButtons, false, true, 5)

  evBox.add(areaInfo)
  bxDetailPanel.add(evBox)

  fmDetail.add(bxDetailPanel)
  return fmDetail


proc makeToolBar(btnStart, btnID, btnIP: Button): Frame =
  #[
    Create Tool Panel which has buttons
  ]#
  let
    boxTool = newBox(Orientation.horizontal, 6)
    fmTool = newFrame()
  
  btnStart.setSizeRequest(80, 80)
  btnID.setSizeRequest(80, 80)
  btnIP.setSizeRequest(80, 80)

  boxTool.add(btnStart)
  boxTool.add(btnID)
  boxTool.add(btnIP)

  fmTool.add(boxTool)

  return fmTool


proc createMainWidget*(imgStatus: Image, lDetails: Label, bStart, bStatus, bID, bIP, bRestart: Button, s: Stack): Box =
  #[
    Create the page for main widget
  ]#
  let
    boxPanel = makeDetailPanel(imgStatus, lDetails, bStatus, bRestart, s)
    boxToolBar = makeToolBar(bStart, bID, bIP)
    mainWidget = newBox(Orientation.vertical, 3)
  
  mainWidget.packStart(boxPanel, false, true, 2)
  mainWidget.packStart(boxToolBar, false, true, 1)
  return mainWidget
