using Gtk;

extern bool is_anonsurf_running();
extern bool is_tor_running();
extern bool is_anonsurf_enabled_boot();


public class AnonSurfApp: GLib.Application {
  private AnonSurfDialogOptions dialog_options;
  private AnonSurfLayout layout;

  public AnonSurfApp(AnonSurfDialogOptions dialog_options) {
    Object(application_id: "org.parrot.anonsurf-gtk");
    this.dialog_options = dialog_options;
  }

  public override void activate() {
    this.layout = new AnonSurfLayout(this.dialog_options);
    this.layout.show_all();
    Timeout.add(200, on_refresh_gui);
    Gtk.main();
  }

  private bool on_refresh_gui() {
    // FIXME crashed here when call nim lib
    bool anonsurf_status = is_anonsurf_running();
    //  bool tor_status = is_tor_running();
    bool anonsurf_boot_status = is_anonsurf_enabled_boot();

    this.layout.main_layout.on_update_layout(anonsurf_status, anonsurf_boot_status);
    return true;
  }
}


int main(string[] args) {
  Gtk.init(ref args);

  var dialog_options = new AnonSurfDialogOptions();
  var app = new AnonSurfApp(dialog_options);
  var sys_tray = new AnonSurfStatusIcon(app, dialog_options);
  return app.run(args);
}
