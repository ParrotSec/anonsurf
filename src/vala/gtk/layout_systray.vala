using Gtk;


public class AnonSurfSystrayMenu: Gtk.Menu {
  public AnonSurfSystrayMenu() {
    var menu_quit = new Gtk.MenuItem.with_label("Quit");
    menu_quit.activate.connect(Gtk.main_quit);

    this.append(menu_quit); // FIXME Incompatible pointer
    this.show_all();
  }
}


public class AnonSurfStatusIcon: StatusIcon {
  private Gtk.Menu menu;
  private AnonSurfApp app;

  public AnonSurfStatusIcon(AnonSurfApp app) {
    this.app = app;
    this.menu = new AnonSurfSystrayMenu();
    this.set_from_icon_name("anonsurf");

    this.activate.connect(on_left_click_systray);
    this.popup_menu.connect(on_right_click_systray);
  }

  private void on_right_click_systray(uint button, uint time) {
    this.menu.popup(null, null, null, button, time);
  }

  private void on_left_click_systray() {
    this.app.activate();
  }
}
