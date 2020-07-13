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


proc makeServiceFrame(labelAnon, labelTor, labelDNS: Label, btnRestart: Button): Frame =
  let
    areaServices = newBox(Orientation.horizontal, 3)
    boxDetail = newBox(Orientation.vertical, 3)
    frameServices = newFrame()
  
  labelAnon.setXalign(0.0)
  labelTor.setXalign(0.0)
  labelDNS.setXalign(0.0)
  boxDetail.add(labelAnon)
  boxDetail.add(labelTor)
  boxDetail.add(labelDNS)

  areaServices.add(boxDetail)
  areaServices.packEnd(btnRestart, false, true, 3)
  
  frameServices.add(areaServices)

  return frameServices


proc makeBootFrame(labelBoot: Label, btnBoot: Button, imgBoot: Image): Frame =
  let
    areaBoot = newBox(Orientation.horizontal, 3)
    field = newBox(Orientation.vertical, 3)
  
  field.add(labelBoot)
  field.add(btnBoot)

  areaBoot.add(imgBoot)
  areaBoot.add(field)
  let
    bootFrame = newFrame()
  
  bootFrame.setLabel("Boot Option")
  bootFrame.setLabelAlign(0.5, 0.5)
  bootFrame.add(areaBoot)
  return bootFrame


proc makeServiceDetails*(
  labelAnon, labelTor, labelDNS, labelBoot: Label,
  btnBoot, btnRestart: Button, imgBoot: Image): Box =
  #[
    Display information about all services
  ]#
  let
    areaService = makeServiceFrame(labelAnon, labelTor, labelDNS, btnRestart)
    areaBoot = makeBootFrame(labelBoot, btnBoot, imgBoot)

  let
    boxDetail = newBox(Orientation.vertical, 3)
  
  boxDetail.add(areaService)
  boxDetail.add(areaBoot)

  return boxDetail
