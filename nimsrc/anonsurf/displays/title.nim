import gintro / gtk


proc makeTitleBar*(): HeaderBar =
  let
    titleBar = newHeaderBar()
  titleBar.setTitle("AnonSurf GUI")
  titleBar.showAll()
  return titleBar