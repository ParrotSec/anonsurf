import gintro / [gtk, gobject]
import ../actions/cores
import about


# type
#   mWidgetObjects = ref object
#     labelTest: Label
#     btnAnonSurf: Button
#     btnRestart: Button
#     btnShowDetails: Button
#     btnShowStatus: Button
#     btnChangeID: Button


proc makeDetailPanel*(imgStatus: Image, btnDetail, btnStatus: Button): Frame =
  #[
    Create the area Detail in main page
    it has image of current AnonSurf
    Button details which switch to details
    Button status which show nyx
  ]#
  let
    fmDetail = newFrame()
    bxButtons = newBox(Orientation.vertical, 3)
    bxDetailPanel = newBox(Orientation.horizontal, 6)

  
  bxDetailPanel.add(imgStatus)
  bxButtons.add(btnDetail)
  bxButtons.add(btnStatus)
  bxDetailPanel.add(bxButtons)

  fmDetail.add(bxDetailPanel)
  return fmDetail


proc makeToolBar*(btnStart, btnID, btnIP: Button): Frame =
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


proc makeBottomBarForMain*(): Box =
  #[
    Create bottom bar
    It has About and Exit button
  ]#
  let
    boxBottomBar = newBox(Orientation.horizontal, 3)
    btnExit = newButton("Exit")
    btnAbout = newButton("About")

  btnExit.connect("clicked", onClickExit)
  btnAbout.connect("clicked", onClickAbout)
  boxBottomBar.add(btnExit)
  boxBottomBar.packEnd(btnAbout, false, true, 3)

  return boxBottomBar
