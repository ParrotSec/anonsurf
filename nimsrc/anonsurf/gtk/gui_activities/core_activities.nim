import gintro / gtk
import gintro / gdk except Window
import .. / .. / options / [option_handler, option_objects]
import os


proc ansurf_gtk_widget_show_details*(e: EventBox, eb: gdk.EventButton, s: Stack): bool =
  s.setVisibleChildName("detail")


proc ansurf_gtk_widget_show_main*(e: EventBox, eb: gdk.EventButton, s: Stack): bool =
  s.setVisibleChildName("main")


proc ansurf_gtk_do_stop*(w: Window | MenuItem) =
  #[
    Close program by click on title bar
  ]#
  mainQuit()


proc ansurf_gtk_do_not_stop*(w: Window, e: Event): bool =
  #[
    Do not close program when user click on button "exit"
    When user clicks on "exit" button, GTK sends signal "delete_event"
    We catch it here and do "hide on delete" instead. Show we can restore
    the main window by showAll() later
  ]#
  return w.hideOnDelete()


proc ansurf_gtk_close_dialog*(d: Dialog) =
  d.destroy()


proc ansurf_gtk_save_config*(c: SurfConfig) =
  const
    mk_torrc = "/usr/lib/anonsurf/make-torrc"
  ansurf_option_sendp(c)
  discard execShellCmd("pkexec env DISPLAY=\"$DISPLAY\" XAUTHORITY=\"$XAUTHORITY\" " & mk_torrc & " new-config")
