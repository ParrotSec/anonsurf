import gintro / [gtk, glib, gobject]


proc on_click_quit(i: MenuItem) =
  mainQuit()


proc ansurf_right_click_menu*(i: StatusIcon, b: int, activeTime: int) =
  let
    menu = newMenu()
    act_quit = newMenuItem()
  
  act_quit.connect("activate", on_click_quit)
  act_quit.set_label("Quit")
  menu.append(act_quit)

  menu.showAll()
  menu.popup(nil, nil, nil, nil, b, activeTime)
