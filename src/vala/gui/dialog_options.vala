using Gtk;


public class SetSafeSock: CheckButton {
  public SetSafeSock(bool saved_option) {
    this.set_label("Enable Safe Sock");
    this.set_active(saved_option);
  }
}


public class SetSandbox: CheckButton {
  public SetSandbox(bool saved_option) {
    this.set_label("Enable Sandbox");
    this.set_active(saved_option);
  }
}


public class SetPlainPort: ComboBoxText {
  public SetPlainPort(int selected_option) {
    this.append_text("Warn plain ports");
    this.append_text("Reject plain ports");
    this.set_active(selected_option);
  }
}


public class SetBridgeMode: ComboBoxText {
  public SetBridgeMode(int selected_option) {
    this.append_text("No Bridges");
    this.append_text("Auto Select");
    this.append_text("Manual");
    this.set_active(selected_option);
  }
  // TODO when user select manual, entry bridge addr should be enabled as well
  // TODO the parser should split values of bridge as well
}


public class SetBridgeProto: Entry {
  public SetBridgeProto(string bridge_addr, int bridge_mode) {
    this.set_placeholder_text("obfs4");
    this.set_tooltip_text("obfs4 or other protocol");

    if (bridge_mode == 2) {
      this.set_sensitive(true);
    }
    else {
      this.set_sensitive(false);
    }
  }
}


public class SetBridgeAddress: Entry {
  public SetBridgeAddress(string bridge_addr, int bridge_mode) {
    this.set_placeholder_text("<address>");
    this.set_tooltip_text("<IP>:<port>");

    if (bridge_mode == 2) {
      this.set_sensitive(true);
    }
    else {
      this.set_sensitive(false);
    }
  }
}


public class SetBridgeFingerprint: Entry {
  public SetBridgeFingerprint(string bridge_addr, int bridge_mode) {
    this.set_placeholder_text("<fingerprint>");
    this.set_tooltip_text("[A-Z\\d]{40}");

    if (bridge_mode == 2) {
      this.set_sensitive(true);
    }
    else {
      this.set_sensitive(false);
    }
  }
}


public class SetBridgeCert: Entry {
  public SetBridgeCert(string bridge_addr, int bridge_mode) {
    this.set_placeholder_text("<cert>");
    this.set_tooltip_text("cert=[\\w\\d\\+\\/]{70}");

    if (bridge_mode == 2) {
      this.set_sensitive(true);
    }
    else {
      this.set_sensitive(false);
    }
  }
}


public class SetBridgeIat: Entry {
  public SetBridgeIat(string bridge_addr, int bridge_mode) {
    this.set_placeholder_text("<iat>");
    this.set_tooltip_text("iat-mode=[\\d]");

    if (bridge_mode == 2) {
      this.set_sensitive(true);
    }
    else {
      this.set_sensitive(false);
    }
  }
}


public class ButtonApply: Button {
  public ButtonApply() {
    this.set_label("Apply");
    this.clicked.connect(on_click_apply_options);
  }

  private void on_click_apply_options() {
    // TODO get options from all objects
    print("Apply\n");
  }
}


public class ButtonCancel: Button {
  private Dialog dialog;

  public ButtonCancel(Dialog dialog) {
    this.set_label("Cancel");
    this.dialog = dialog;
    this.clicked.connect(on_click_cancel_options);
  }

  private void on_click_cancel_options() {
    this.dialog.hide();
  }
}


public class AnonSurfDialogOptions: Dialog {
  private SetPlainPort cmbxt_plain_port;
  private SetBridgeMode cmbxt_bridge_mode;
  private SetBridgeProto entr_bridge_proto;
  private SetBridgeAddress entr_bridge_addr;
  private SetBridgeFingerprint entr_bridge_fing;
  private SetBridgeCert entr_bridge_cert;
  private SetBridgeIat entr_bridge_iat;
  private SetSafeSock cbtn_safe_sock_port;
  private SetSandbox cbtn_sandbox_mode;
  private ButtonApply button_apply;
  private ButtonCancel button_cancel;

  private Box box_dialog_options;

  public AnonSurfDialogOptions() {
    // TODO parse options here
    // template value to pass
    int selected_option = 0;
    string bridge_addr = "";
    string bridge_proto = "obfs4";
    string finger_print = "abd";
    string bridge_cert = "def";
    string bridge_iat = "1";
    bool enabled_option = true;
    // End of tmp values

    cmbxt_plain_port = new SetPlainPort(selected_option);
    cmbxt_bridge_mode = new SetBridgeMode(selected_option);

    entr_bridge_proto = new SetBridgeProto(bridge_proto, selected_option);
    entr_bridge_addr = new SetBridgeAddress(bridge_addr, selected_option);
    entr_bridge_fing = new SetBridgeFingerprint(finger_print, selected_option);
    entr_bridge_cert = new SetBridgeCert(bridge_cert, selected_option);
    entr_bridge_iat = new SetBridgeIat(bridge_iat, selected_option);

    cbtn_safe_sock_port = new SetSafeSock(enabled_option);
    cbtn_sandbox_mode = new SetSandbox(enabled_option);

    button_apply = new ButtonApply();
    button_cancel = new ButtonCancel(this);

    this.set_title("AnonSurf Options");
    this.set_icon_name("preferences-desktop");
    this.set_resizable(false);

    var content_area = this.get_content_area(); // FIXME: c source complains about incompatible pointer
    dialog_options_create_layout();
    content_area.add(box_dialog_options);
  }

  private void dialog_options_create_option_layout() {
    var box_combo_box_area = new Box(Orientation.VERTICAL, 3);
    box_combo_box_area.pack_start(cmbxt_plain_port, false, true, 3);
    box_combo_box_area.pack_start(cmbxt_bridge_mode, false, true, 3);
    box_combo_box_area.pack_start(entr_bridge_proto, false, true, 3);
    box_combo_box_area.pack_start(entr_bridge_addr, false, true, 3);
    box_combo_box_area.pack_start(entr_bridge_fing, false, true, 3);
    box_combo_box_area.pack_start(entr_bridge_cert, false, true, 3);
    box_combo_box_area.pack_start(entr_bridge_iat, false, true, 3);

    var box_check_button_area = new Box(Orientation.VERTICAL, 3);
    box_check_button_area.pack_start(cbtn_safe_sock_port, false, true, 3);
    box_check_button_area.pack_start(cbtn_sandbox_mode, false, true, 3);

    var box_option_area = new Box(Orientation.HORIZONTAL, 3);
    box_option_area.pack_start(box_combo_box_area, false, true, 3);
    box_option_area.pack_start(box_check_button_area, false, true, 3);

    box_dialog_options.pack_start(box_option_area, false, true, 3);
  }

  private void dialog_options_add_button_layout() {
    var box_button_area = new Box(Orientation.HORIZONTAL, 3);

    box_button_area.pack_start(button_apply, false, true, 3);
    box_button_area.pack_end(button_cancel, false, true, 3);

    box_dialog_options.pack_end(box_button_area, true, true, 3);
  }

  private void dialog_options_create_layout() {
    box_dialog_options = new Box(Orientation.VERTICAL, 3);
    dialog_options_create_option_layout();
    dialog_options_add_button_layout();
  }

  public void invoke() {
    // TODO parse saved settings here
    this.show_all();
    this.run();
    this.hide();
  }
}
