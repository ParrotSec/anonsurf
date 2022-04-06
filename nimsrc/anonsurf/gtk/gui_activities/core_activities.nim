import gintro / gtk
import gintro / gdk except Window


proc ansurf_gtk_widget_show_details*(e: EventBox, eb: gdk.EventButton, s: Stack): bool =
  s.setVisibleChildName("detail")


proc ansurf_gtk_widget_show_main*(e: EventBox, eb: gdk.EventButton, s: Stack): bool =
  s.setVisibleChildName("main")


proc ansurf_gtk_do_stop*(w: Window) =
  #[
    Close program by click on title bar
  ]#
  mainQuit()
  # discard w.hideOnDelete()


proc ansurf_gtk_on_window_state_event*(w: Window) =
  w.hide()
