import gintro / [gtk, gobject]
import .. / cores / images
import about


proc makeBottomBarForDetail(bBack: Button): Box =
  #[
    Display bottom bar that has btnExit and btnBack
  ]#
  let
    boxBottomBar = newBox(Orientation.horizontal, 3)
    # btnExit = newButton("Exit")
    btnAbout = newButton("")
    imgAbout = newImageFromPixbuf(aboutIcon)
  
  boxBottomBar.add(bBack)

  btnAbout.setImage(imgAbout)
  btnAbout.connect("clicked", onClickAbout)

  boxBottomBar.packEnd(btnAbout, false, true, 3)

  return boxBottomBar


proc makeServiceFrame(labelServices, labelPorts, labelDNS: Label): Frame =
  #[
    Create a Frame for service status
  ]#
  let
    areaServices = newBox(Orientation.vertical, 3)
    frameServices = newFrame()
  
  labelServices.setXalign(0.04)
  labelPorts.setXalign(0.04)
  labelDNS.setXalign(0.04)

  areaServices.add(labelServices)
  areaServices.add(labelPorts)
  areaServices.add(labelDNS)
  
  frameServices.add(areaServices)

  return frameServices


proc makeBootFrame(labelBoot: Label, btnBoot: Button, imgBoot: Image): Frame =
  #[
    Create frame for boot status
  ]#
  let
    areaBoot = newBox(Orientation.horizontal, 3)
    field = newBox(Orientation.vertical, 3)
  
  field.packStart(labelBoot, false, true, 3)
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
  btnBoot: Button,
  imgBoot: Image): Box =
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
  btnBoot, btnBack: Button,
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
    boxBottomBar = makeBottomBarForDetail(btnBack)
  
  boxDetailWidget.add(boxServices)
  boxDetailWidget.packEnd(boxBottomBar, false, true, 3)
  return boxDetailWidget
