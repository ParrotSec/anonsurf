using Gtk;


public class AnonSurfStatusIcon {
  private StatusIcon systray;
  private GLib.Menu menu;

  public void init_status_icon() {
    systray = new StatusIcon.from_icon_name("anonsurf");
    // systray.active.connect(left_click_on_systray);
    //  systray.popup_menu.connect(on_right_click_systray);
  }

  public void init_rightclick_menu() {
    menu = new GLib.Menu();
    //  anonsurf_actions = new GLib.Menu();
    //  var menu_quit = new ImageMenuItem.from_stock(Stock.QUIT, null);
    var menu_quit = new GLib.MenuItem("Quit", null);
    //  menu_quit.activate.connect(Gtk.main_quit);
    menu.append_item(menu_quit);
    // FIXME need to set popover
    //  menu.show_all();
  }

  //  private void on_right_click_systray(uint button, uint time) {
  //    menu.popup(null, null, null, button, time);
  //  }
}


public class AnonSurfLayout: Gtk.Window {
  public AnonSurfLayout() {
    this.set_titlebar(new AnonSurfTitleBar());
    this.set_icon_name("anonsurf");
    //  var box_main_app = new Box(Orientation.VERTICAL, 3);
    //  var widget_detail = new MainLayout();

    //  box_main_app.pack_start(widget_detail, false, true, 3);
    //  this.add(box_main_app);
    this.add(new MainLayout());
    //  this.show_all();
  }
}


public class AnonSurfApp: GLib.Application {
  public AnonSurfApp() {
    Object(application_id: "org.parrot.anonsurf-gtk");
  }

  public override void activate() {
    var window = new AnonSurfLayout();
    window.show_all();
    Gtk.main();
  }
}


int main(string[] args) {
  Gtk.init(ref args);

  var app = new AnonSurfApp();
  var sys_tray = new AnonSurfStatusIcon();

  sys_tray.init_status_icon();

  return app.run(args);
}
