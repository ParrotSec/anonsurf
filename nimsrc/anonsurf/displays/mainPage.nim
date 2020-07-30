import gintro / [gtk, gobject]
# import opts


proc makeDetailPanel(imgStatus: Image, labDetails: Label, btnDetail, btnStatus: Button): Frame =
  #[
    Create the area Detail in main page
    it has image of current AnonSurf
    Button details which switch to details
    Button status which show nyx
  ]#
  let
    fmDetail = newFrame()
    areaInfo = newBox(Orientation.vertical, 3)
    bxButtons = newBox(Orientation.horizontal, 3)
    bxDetailPanel = newBox(Orientation.horizontal, 6)

  bxDetailPanel.add(imgStatus)
  bxButtons.packStart(btnDetail, false, true, 4)
  bxButtons.packStart(btnStatus, false, true, 2)

  areaInfo.packStart(labDetails, false, true, 3)
  areaInfo.packEnd(bxButtons, false, true, 5)
  bxDetailPanel.add(areaInfo)

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


proc makeBottomBarForMain(btnRestart: Button): Box =
  #[
    Create bottom bar
    It has About and Exit button
  ]#
  let
    boxBottomBar = newBox(Orientation.horizontal, 3)
    imgRestart = newImageFromIconName("reload", 3)
    btnOptions = newButton("")
    imgOptions = newImageFromIconName("system-run", 3)
  btnRestart.setImage(imgRestart)

  btnOptions.setImage(imgOptions)
  # btnOptions.connect("clicked", makeOptionsDialog)

  boxBottomBar.packStart(btnRestart, false, true, 3)
  # boxBottomBar.packEnd(btnOptions, false, true, 3)

  return boxBottomBar


proc createMainWidget*(imgStatus: Image, lDetails: Label, bStart, bDetail, bStatus, bID, bIP, bRestart: Button): Box =
  #[
    Create the page for main widget
  ]#
  let
    boxPanel = makeDetailPanel(imgStatus, lDetails, bDetail, bStatus)
    boxToolBar = makeToolBar(bStart, bID, bIP)
    bottomBar = makeBottomBarForMain(bRestart)
    mainWidget = newBox(Orientation.vertical, 3)
  
  mainWidget.packStart(boxPanel, false, true, 2)
  mainWidget.packStart(boxToolBar, false, true, 1)
  mainWidget.packEnd(bottomBar, false, true, 2)
  return mainWidget
