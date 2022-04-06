import gintro / gtk
import gintro / gdk except Window


proc ansurf_gtk_do_show_details*(b: Button, s: Stack) =
  if b.label == "Details":
    s.setVisibleChildName("detail")
    b.label = "Back"
  else:
    s.setVisibleChildName("main")
    b.label = "Details"


# proc ansurf_gtk_do_exit*(b: Button) =
#   #[
#     Close program by click on exit button
#   ]#
#   mainQuit()


proc ansurf_gtk_widget_details*(e: EventBox, eb: gdk.EventButton, s: Stack): bool =
  s.setVisibleChildName("detail")
  # discard


proc ansurf_gtk_do_stop*(w: Window) =
  #[
    Close program by click on title bar
  ]#
  mainQuit()
  # discard w.hideOnDelete()


proc ansurf_gtk_on_window_state_event*(w: Window) =
  w.hide()
