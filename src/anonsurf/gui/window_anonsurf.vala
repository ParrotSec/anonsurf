using Gtk;


public class AnonSurfLayout: Gtk.Window {
  public MainLayout main_layout;

  public AnonSurfLayout(AnonSurfDialogOptions dialog_options) {
    this.main_layout = new MainLayout();
    this.set_titlebar(new AnonSurfTitleBar(dialog_options));
    this.set_icon_name("anonsurf");
    this.set_resizable(false);
    this.add(this.main_layout);
  }
}
