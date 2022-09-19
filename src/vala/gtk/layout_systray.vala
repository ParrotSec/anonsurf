using Gtk;


public class AnonSurfStatusIcon: StatusIcon {
  private GLib.Menu menu;
  private AnonSurfApp app;

  public AnonSurfStatusIcon(AnonSurfApp app) {
    this.app = app;
    this.set_from_icon_name("anonsurf");
    this.activate.connect(on_left_click_systray);
  }

  //  public void init_rightclick_menu() {
  //    menu = new GLib.Menu();
  //    //  anonsurf_actions = new GLib.Menu();
  //    //  var menu_quit = new ImageMenuItem.from_stock(Stock.QUIT, null);
  //    var menu_quit = new GLib.MenuItem("Quit", null);
  //    //  menu_quit.activate.connect(Gtk.main_quit);
  //    menu.append_item(menu_quit);
  //    // FIXME need to set popover
  //    //  menu.show_all();
  //  }

  //  //  private void on_right_click_systray(uint button, uint time) {
  //  //    menu.popup(null, null, null, button, time);
  //  //  }

  private void on_left_click_systray() {
    this.app.activate();
  }
}