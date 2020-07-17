import gintro / gtk
# import .. / .. / actions / cores


proc makeBottomBarForDetail(bBack, bRestart: Button): Box =
  #[
    Display bottom bar that has btnExit and btnBack
  ]#
  let
    boxBottomBar = newBox(Orientation.horizontal, 3)
    # btnExit = newButton("Exit")
  
  boxBottomBar.add(bBack)
  boxBottomBar.packEnd(bRestart, false, true, 3)

  # btnExit.connect("clicked", onclickExit)
  # boxBottomBar.packEnd(btnExit, false, true, 3)

  return boxBottomBar


proc makeServiceFrame(labelServices, labelPorts, labelDNS: Label): Frame =
  let
    areaServices = newBox(Orientation.vertical, 3)
    # boxDetail = newBox(Orientation.vertical, 3)
    frameServices = newFrame()
  
  labelServices.setXalign(0.0)
  labelPorts.setXalign(0.0)
  labelDNS.setXalign(0.0)
  # boxDetail.add(labelAnon)
  # boxDetail.add(labelTor)
  # boxDetail.add(labelDNS)

  # areaServices.add(boxDetail)
  areaServices.add(labelServices)
  areaServices.add(labelPorts)
  areaServices.add(labelDNS)
  
  frameServices.add(areaServices)

  return frameServices


proc makeBootFrame(labelBoot: Label, btnBoot: Button, imgBoot: Image): Frame =
  let
    areaBoot = newBox(Orientation.horizontal, 3)
    field = newBox(Orientation.vertical, 3)
  
  field.add(labelBoot)
  field.add(btnBoot)

  areaBoot.packStart(imgBoot, false, true, 10)
  areaBoot.packStart(field, false, true, 14)
  let
    bootFrame = newFrame()
  
  bootFrame.setLabel("Boot Option")
  bootFrame.setLabelAlign(0.5, 0.5)
  bootFrame.add(areaBoot)
  return bootFrame


proc makeServiceDetails(
  labelServices, labelPorts, labelDNS, labelBoot: Label,
  btnBoot: Button, imgBoot: Image): Box =
  #[
    Display information about all services
  ]#
  let
    areaService = makeServiceFrame(labelServices, labelPorts, labelDNS)
    areaBoot = makeBootFrame(labelBoot, btnBoot, imgBoot)

  let
    boxDetail = newBox(Orientation.vertical, 3)
  
  boxDetail.add(areaService)
  boxDetail.add(areaBoot)

  return boxDetail


proc createDetailWidget*(
  labelServices, labelPorts, labelDNS, labelBoot: Label,
  btnBoot, btnBack, btnRestart: Button,
  imgBoot: Image,
  ): Box =
  #[
    Create a page to display current detail of AnonSurf
  ]#
  let
    boxServices = makeServiceDetails(
      labelServices, labelPorts, labelDNS, labelBoot, btnBoot, imgBoot
    )
    boxDetailWidget = newBox(Orientation.vertical, 3)
    boxBottomBar = makeBottomBarForDetail(btnBack, btnRestart)
  
  boxDetailWidget.add(boxServices)
  boxDetailWidget.packEnd(boxBottomBar, false, true, 3)
  return boxDetailWidget
