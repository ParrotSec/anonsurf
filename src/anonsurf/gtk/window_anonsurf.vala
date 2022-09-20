using Gtk;


public class AnonSurfLayout: Gtk.Window {
  public AnonSurfLayout(AnonSurfDialogOptions dialog_options) {
    this.set_titlebar(new AnonSurfTitleBar(dialog_options));
    this.set_icon_name("anonsurf");
    this.set_resizable(false);
    this.add(new MainLayout());
  }
}
