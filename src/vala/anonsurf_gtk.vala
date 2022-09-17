using Gtk;


public class AnonSurfLayout: Gtk.Window {
  public AnonSurfLayout() {
    this.set_titlebar(new AnonSurfTitleBar());
    this.set_icon_name("anonsurf");
    this.set_resizable(false);
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
