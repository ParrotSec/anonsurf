import gintro / [gtk, gobject]
import .. / actions / gtkClick
import about


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
  bxButtons.add(btnDetail)
  bxButtons.add(btnStatus)

  areaInfo.add(labDetails)
  areaInfo.packEnd(bxButtons, false, true, 3)
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


proc makeBottomBarForMain(): Box =
  #[
    Create bottom bar
    It has About and Exit button
  ]#
  let
    boxBottomBar = newBox(Orientation.horizontal, 3)
    btnExit = newButton("Exit")
    btnAbout = newButton("About")
    imgAbout = newImageFromIconName("help-about", 3)
    imgExit = newImageFromIconName("exit", 3)

  btnExit.setImage(imgExit)
  btnExit.connect("clicked", onClickExit)
  btnAbout.setImage(imgAbout)
  btnAbout.connect("clicked", onClickAbout)
  boxBottomBar.add(btnExit)
  boxBottomBar.packEnd(btnAbout, false, true, 3)

  return boxBottomBar


proc createMainWidget*(imgStatus: Image, lDetails: Label, bStart, bDetail, bStatus, bID, bIP: Button): Box =
  #[
    Create the page for main widget
  ]#
  let
    boxPanel = makeDetailPanel(imgStatus, lDetails, bDetail, bStatus)
    boxToolBar = makeToolBar(bStart, bID, bIP)
    bottomBar = makeBottomBarForMain()
    mainWidget = newBox(Orientation.vertical, 3)
  
  mainWidget.add(boxPanel)
  mainWidget.add(boxToolBar)
  mainWidget.packEnd(bottomBar, false, true, 3)
  return mainWidget
