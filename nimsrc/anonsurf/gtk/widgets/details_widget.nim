import gintro / [gtk, gdk, gobject, glib]
import .. / gui_activities / core_activities



proc makeServiceFrame(labelServices, labelPorts, labelDNS: Label, s: Stack): Frame =
  #[
    Create a Frame for service status
  ]#
  let
    areaServices = newBox(Orientation.vertical, 3)
    frameServices = newFrame()
    evBox = newEventBox()
  
  labelServices.setXalign(0.04)
  labelPorts.setXalign(0.04)
  labelDNS.setXalign(0.04)

  areaServices.add(labelServices)
  areaServices.add(labelPorts)
  areaServices.add(labelDNS)

  evBox.connect("button-press-event", ansurf_gtk_widget_show_main, s)
  evBox.add(areaServices)
  
  # frameServices.add(areaServices)
  frameServices.add(evBox)

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
  imgBoot: Image,
  s: Stack): Box =
  #[
    Display information about all services
  ]#
  let
    areaService = makeServiceFrame(labelServices, labelPorts, labelDNS, s)
    areaBoot = makeBootFrame(labelBoot, btnBoot, imgBoot)

  let
    boxDetail = newBox(Orientation.vertical, 3)
  
  boxDetail.add(areaService)
  boxDetail.add(areaBoot)

  return boxDetail


proc createDetailWidget*(
  labelServices, labelPorts, labelDNS, labelBoot: Label,
  btnBoot: Button,
  imgBoot: Image,
  s: Stack): Box =
  #[
    Create a page to display current detail of AnonSurf
  ]#
  let
    boxServices = makeServiceDetails(
      labelServices, labelPorts, labelDNS, labelBoot, btnBoot, imgBoot, s
    )
    boxDetailWidget = newBox(Orientation.vertical, 3)
  
  boxDetailWidget.add(boxServices)
  return boxDetailWidget
