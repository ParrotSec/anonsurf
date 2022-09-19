using Gtk;


public class AnonSurfApp: GLib.Application {
  private AnonSurfDialogOptions dialog_options;

  public AnonSurfApp(AnonSurfDialogOptions dialog_options) {
    Object(application_id: "org.parrot.anonsurf-gtk");
    this.dialog_options = dialog_options;
  }

  public override void activate() {
    var window = new AnonSurfLayout(this.dialog_options);
    window.show_all();
    Gtk.main();
  }
}


int main(string[] args) {
  Gtk.init(ref args);

  var dialog_options = new AnonSurfDialogOptions();
  var app = new AnonSurfApp(dialog_options);
  var sys_tray = new AnonSurfStatusIcon(app, dialog_options);
  return app.run(args);
}
