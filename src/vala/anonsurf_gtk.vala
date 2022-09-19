using Gtk;


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
  var sys_tray = new AnonSurfStatusIcon(app);
  return app.run(args);
}
