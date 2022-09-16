using Gtk;


public class AnonSurfTitleBar: HeaderBar {
  private Button button_settings;
  private Button button_about;

  public AnonSurfTitleBar() {
    init_button_settings();
    init_button_about();

    this.set_show_close_button(true);
    this.set_title("AnonSurf");
    this.pack_end(button_about);
    this.pack_start(button_settings);
    this.set_decoration_layout(":close");
  }

  private void init_button_settings() {
    button_settings = new Button.from_icon_name("preferences-desktop");
  }

  private void init_button_about() {
    button_about = new Button.from_icon_name("help-about");
    button_about.clicked.connect(on_click_about);
  }

  private void on_click_about() {
    var dialog_about = new AnonSurfAbout();
    dialog_about.run();
    dialog_about.destroy();
  }
}
