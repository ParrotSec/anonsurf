import gintro / [gtk, gobject]
import gui_activities / [systray_activities, core_activities]
import .. / cores / commons / ansurf_objects


proc ansurf_right_click_menu*(i: StatusIcon, b: int, activeTime: int, cb_send_msg: callback_send_messenger) =
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
    item_change_id = newMenuItemWithLabel("Change ID")
    item_ansurf_control = newMenuItemWithLabel("AnonSurf")

  # Sub menu
  ansurf_control_menu.append(item_start_surf)
  ansurf_control_menu.append(item_stop_surf)
  ansurf_control_menu.append(item_change_id)
  ansurf_control_menu.append(item_restart_surf)
  item_ansurf_control.setSubmenu(ansurf_control_menu)

  item_start_surf.connect("activate", ansurf_menu_do_start, cb_send_msg)
  item_stop_surf.connect("activate", ansurf_menu_do_stop, cb_send_msg)
  item_restart_surf.connect("activate", ansurf_menu_do_restart, cb_send_msg)
  item_change_id.connect("activate", ansurf_menu_do_changeid, cb_send_msg)

  # Main menu
  right_click_menu.append(item_ansurf_control)
  right_click_menu.append(item_status_surf)
  right_click_menu.append(item_my_ip)
  right_click_menu.append(item_quit)

  item_status_surf.connect("activate", ansurf_menu_do_status, cb_send_msg)
  item_my_ip.connect("activate", ansurf_menu_do_myip, cb_send_msg)
  item_quit.connect("activate", ansurf_gtk_do_stop)

  right_click_menu.showAll()
  right_click_menu.popup(nil, nil, nil, nil, b, activeTime)


proc ansurf_left_click*(i: StatusIcon, w: ApplicationWindow) =
  w.showAll()
