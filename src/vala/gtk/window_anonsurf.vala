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
  }
}