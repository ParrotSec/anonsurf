import gintro / gtk


proc makeDetailPanel(imgStatus: Image, labDetails: Label, btnStatus, btnRestart: Button): Frame =
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
  bxButtons.packStart(btnRestart, false, true, 4)
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


proc createMainWidget*(imgStatus: Image, lDetails: Label, bStart, bStatus, bID, bIP, bRestart: Button): Box =
  #[
    Create the page for main widget
  ]#
  let
    boxPanel = makeDetailPanel(imgStatus, lDetails, bStatus, bRestart)
    boxToolBar = makeToolBar(bStart, bID, bIP)
    mainWidget = newBox(Orientation.vertical, 3)
  
  mainWidget.packStart(boxPanel, false, true, 2)
  mainWidget.packStart(boxToolBar, false, true, 1)
  return mainWidget
