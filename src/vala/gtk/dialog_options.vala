using Gtk;


public class AnonSurfDialogOptions: Dialog {
  private ComboBoxText cbt_plain_port;
  private ComboBoxText cbt_bridge_mode;
  private Entry ent_bridge_addr;
  private CheckButton enable_safe_sock_port;
  private CheckButton enable_sandbox_mode;
  private Button button_apply;
  private Button button_cancel;

  private Box box_dialog_options;

  public AnonSurfDialogOptions() {
    init_all_objects();
    this.set_title("AnonSurf Options");
    this.set_icon_name("preferences-desktop");
    this.set_resizable(false);

    var content_area = this.get_content_area(); // FIXME: c source complains about incompatible pointer
    content_area.add(box_dialog_options);
    this.show_all();
  }

  private void init_all_objects() {
    init_cbt_plain_port();
    init_cbt_bridge_mode();
    init_ent_bridge_addr();
    init_checkbuttons();
    init_button_apply();
    init_button_cancel();

    init_dialog_options();
  }

  private void init_ent_bridge_addr() {
    ent_bridge_addr = new Entry();
    ent_bridge_addr.set_placeholder_text("obfs4 <address> <fingerprint> <cert> <iat>");
    ent_bridge_addr.set_tooltip_text("obfs4 <IP>:<port> [A-Z\\d]{40} cert=[\\w\\d\\+\\/]{70} iat-mode=[\\d]");
    // FIXME set_text bridge addr from parser
    // FIXME set sensitive if birdge mode is enabled
    /*
    if (bridge_mode == 2) {
      ent_bridge_addr.set_sensitive(true);
    }
    else {
      ent_bridge_addr.set_sensitive(false);
    }
     */
  }

  private void init_cbt_plain_port() {
    cbt_plain_port = new ComboBoxText();
    cbt_plain_port.append_text("Warn plain ports");
    cbt_plain_port.append_text("Reject plain ports");
    cbt_plain_port.set_active(0); // FIXME use refresher and parser
  }

  private void init_cbt_bridge_mode() {
    cbt_bridge_mode = new ComboBoxText();
    cbt_bridge_mode.append_text("No Bridges");
    cbt_bridge_mode.append_text("Auto Select");
    cbt_bridge_mode.append_text("Manual");
    cbt_bridge_mode.set_active(0); // FIXME use fresher and parser for correct value
  }

  private void init_checkbuttons() {
    enable_safe_sock_port = new CheckButton.with_label("Safe Sock Port");
    enable_sandbox_mode = new CheckButton.with_label("Sandbox Mode");
  }

  private void init_button_apply() {
    button_apply = new Button.with_label("Apply");
  }

  private void init_button_cancel() {
    button_cancel = new Button.with_label("Cancel");
    button_cancel.clicked.connect(on_click_cancel);
  }

  private void on_click_apply() {

  }

  private void on_click_cancel() {
    this.destroy();
  }

  private void init_dialog_options() {
    var box_combo_box_area = new Box(Orientation.VERTICAL, 3);
    var box_check_button_area = new Box(Orientation.VERTICAL, 3);
    var box_option_area = new Box(Orientation.HORIZONTAL, 3);
    var box_button_area = new Box(Orientation.HORIZONTAL, 3);
    box_dialog_options = new Box(Orientation.VERTICAL, 3);

    box_combo_box_area.pack_start(cbt_plain_port, false, true, 3);
    box_combo_box_area.pack_start(cbt_bridge_mode, false, true, 3);
    box_combo_box_area.pack_start(ent_bridge_addr, false, true, 3);

    box_check_button_area.pack_start(enable_safe_sock_port, false, true, 3);
    box_check_button_area.pack_start(enable_sandbox_mode, false, true, 3);

    box_button_area.pack_start(button_apply, false, true, 3);
    box_button_area.pack_end(button_cancel, false, true, 3);

    box_option_area.pack_start(box_combo_box_area, false, true, 3);
    box_option_area.pack_start(box_check_button_area, false, true, 3);

    box_dialog_options.pack_start(box_option_area, false, true, 3);
    box_dialog_options.pack_end(box_button_area, true, true, 3);
  }
}
