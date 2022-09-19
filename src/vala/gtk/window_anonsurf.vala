using Gtk;


public class AnonSurfLayout: Gtk.Window {
  public AnonSurfLayout() {
    this.set_titlebar(new AnonSurfTitleBar());
    this.set_icon_name("anonsurf");
    this.set_resizable(false);
    this.add(new MainLayout());
  }
}
