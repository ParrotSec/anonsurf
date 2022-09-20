using Gtk;


public class ButtonSettings: Button {
  private AnonSurfDialogOptions dialog_options;

  public ButtonSettings(AnonSurfDialogOptions dialog_options) {
    this.set_image(new Image.from_icon_name("preferences-desktop", BUTTON));
    this.dialog_options = dialog_options;
    this.clicked.connect(on_click_settings);
  }

  private void on_click_settings() {
    this.dialog_options.invoke();
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
  public AnonSurfTitleBar(AnonSurfDialogOptions dialog_options) {
    this.set_show_close_button(true);
    this.set_title("AnonSurf");
    this.pack_end(new ButtonAbout());
    this.pack_start(new ButtonSettings(dialog_options));
    this.set_decoration_layout(":close");
  }
}
