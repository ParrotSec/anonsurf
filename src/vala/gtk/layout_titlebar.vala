using Gtk;


public class ButtonSettings: Button {
  public ButtonSettings() {
    this.set_image(new Image.from_icon_name("preferences-desktop", BUTTON));
    this.clicked.connect(on_click_settings);
  }

  private void on_click_settings() {
    var dialog_options = new AnonSurfDialogOptions();
    dialog_options.run();
    dialog_options.destroy();
  }
}


public class ButtonAbout: Button {
  public ButtonAbout() {
    this.set_image(new Image.from_icon_name("help-about", BUTTON));
    this.clicked.connect(on_click_about);
  }

  private void on_click_about() {
    var dialog_about = new AnonSurfDialogAbout();
    dialog_about.run();
    dialog_about.destroy();
  }
}


public class AnonSurfTitleBar: HeaderBar {
  public AnonSurfTitleBar() {
    this.set_show_close_button(true);
    this.set_title("AnonSurf");
    this.pack_end(new ButtonAbout());
    this.pack_start(new ButtonSettings());
    this.set_decoration_layout(":close");
  }
}
