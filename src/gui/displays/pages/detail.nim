import gintro / [gtk, gobject]
import .. / .. / actions / cores


proc makeBottomBarForDetail*(bBack: Button): Box =
  #[
    Display bottom bar that has btnExit and btnBack
  ]#
  let
    boxBottomBar = newBox(Orientation.horizontal, 3)
    btnExit = newButton("Exit")
  
  boxBottomBar.add(bBack)

  btnExit.connect("clicked", onclickExit)
  boxBottomBar.packEnd(btnExit, false, true, 3)

  return boxBottomBar


proc makeServiceDetails*(lDNS: Label): Box =
  #[
    Display information about all services
  ]#
  lDNS.text = "LocalHost"
  let
    boxServices = newBox(Orientation.vertical, 3)
  
  boxServices.add(lDNS)

  return boxServices
