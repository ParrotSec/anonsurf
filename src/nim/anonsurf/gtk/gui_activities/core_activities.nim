import gintro / [gtk, gio]
import gintro / gdk except Window
import .. / .. / options / [option_handler, option_objects]


proc ansurf_gtk_widget_show_details*(e: EventBox, eb: gdk.EventButton, s: Stack): bool =
  s.setVisibleChildName("detail")


proc ansurf_gtk_widget_show_main*(e: EventBox, eb: gdk.EventButton, s: Stack): bool =
  s.setVisibleChildName("main")


proc ansurf_gtk_do_stop*(w: Window | gtk.MenuItem) =
  #[
    Close program by click on title bar
  ]#
  quit()


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
  ansurf_option_sendp(c)


proc daemon(a1, a2: cint): cint {.importc, header: "<unistd.h>"}


proc ansurf_gtk_start_daemon*() =
  #[
    DAEMON(3)
    If nochdir is zero, pwd is /; otherwise, the current working directory is left unchanged.
    If noclose is zero, all stdin, stdout, stderror > /dev/null, no changes are made to these file descriptors.
  ]#
  discard daemon(1, 1)
