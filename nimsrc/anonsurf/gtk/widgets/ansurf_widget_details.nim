import gintro / [gtk, gdk, gobject, glib]
import .. / gui_activities / [core_activities, widget_details]
import .. / .. / cores / commons / ansurf_objects


proc ansurf_detail_w_service_area*(labelServices, labelPorts, labelDNS: Label, s: Stack): Frame =
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

  frameServices.add(evBox)

  return frameServices


proc ansurf_detail_w_boot_area*(labelBoot: Label, btnBoot: Button, imgBoot: Image, cb_send_msg: callback_send_messenger): Frame =
  #[
    Create Frame for boot status
  ]#
  let
    areaBoot = newBox(Orientation.horizontal, 3)
    field = newBox(Orientation.vertical, 3)

  btnBoot.connect("clicked", ansurf_gtk_do_enable_disable_boot, cb_send_msg)
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


proc ansurf_details_w_main_area*(box_services, box_boot: Frame): Box =
  let
    detail_widget = newBox(Orientation.vertical, 3)

  detail_widget.packStart(box_services, false, true, 2)
  detail_widget.packStart(box_boot, false, true, 2)

  return detail_widget
