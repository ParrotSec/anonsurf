import gintro / [gtk, gobject]
import .. / cores / handle_activities
import gui_activities / main_widget_activities


let cb_send_msg = cli_init_callback_msg(true)


proc on_click_quit(i: MenuItem) =
  mainQuit()


proc ansurf_right_click_menu*(i: StatusIcon, b: int, activeTime: int) =
  # TODO open anonsurf
  let
    menu = newMenu()
    item_my_ip = newMenuItemWithlabel("Check IP")
    item_quit = newMenuItemWithlabel("Quit")
  
  item_my_ip.connect("activate", ansurf_gtk_do_myip, cb_send_msg)
  menu.append(item_my_ip)

  item_quit.connect("activate", on_click_quit)
  menu.append(item_quit)

  menu.showAll()
  menu.popup(nil, nil, nil, nil, b, activeTime)


proc ansurf_left_click*(i: StatusIcon, w: Window) =
  # https://www.codeproject.com/Articles/27142/Minimize-to-tray-with-GTK
  w.show()
  w.deiconify()
  # w.present()
