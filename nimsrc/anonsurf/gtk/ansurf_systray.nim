import gintro / [gtk, gobject]
import .. / cores / handle_activities
import gui_activities / [main_widget_activities, core_activities]


let cb_send_msg = cli_init_callback_msg(true)


proc ansurf_right_click_menu*(i: StatusIcon, b: int, activeTime: int) =
  # TODO refresh menu
  let
    right_click_menu = newMenu()
    ansurf_control_menu = newMenu()
    item_my_ip = newMenuItemWithlabel("Check IP")
    item_quit = newMenuItemWithlabel("Quit")
    item_start_surf = newMenuItemWithLabel("Start")
    item_stop_surf = newMenuItemWithLabel("Stop")
    item_restart_surf = newMenuItemWithLabel("Restart")
    item_status_surf = newMenuItemWithLabel("Status")
    item_ansurf_control = newMenuItemWithLabel("AnonSurf")

  # Sub menu
  ansurf_control_menu.append(item_start_surf)
  ansurf_control_menu.append(item_stop_surf)
  ansurf_control_menu.append(item_restart_surf)
  ansurf_control_menu.append(item_status_surf)
  item_ansurf_control.setSubmenu(ansurf_control_menu)

  # Main menu
  right_click_menu.append(item_ansurf_control)
  item_my_ip.connect("activate", ansurf_gtk_do_myip, cb_send_msg)
  right_click_menu.append(item_my_ip)
  item_quit.connect("activate", ansurf_gtk_do_stop)
  right_click_menu.append(item_quit)

  right_click_menu.showAll()
  right_click_menu.popup(nil, nil, nil, nil, b, activeTime)


proc ansurf_left_click*(i: StatusIcon, w: Window) =
  w.showAll()
