using Gtk;

const uchar button_size_x = 105;
const uchar button_size_y = 65;
const uchar button_boot_size_x = 60;
const uchar button_boot_size_y = 48;


public class LabelBootStatus: Label {
  public LabelBootStatus(bool is_enabled) {
    if (is_enabled == true) {
      this.set_label("Enabled");
    }
    else {
      this.set_label("Disabled");
    }
  }
}


public class LabelAnonSurfStatus: Label {
  public LabelAnonSurfStatus() { // TODO get the status from variable
    this.set_label("Deactivated");
  }
}


public class ButtonAnonSurfAction: Button {
  public ButtonAnonSurfAction() { // TODO get status from variable
    this.set_label("Start");
    this.set_size_request(button_size_x, button_size_y);
    this.clicked.connect(on_click_anonsurf_action);
  }

  private void on_click_anonsurf_action() {
    if (this.get_label() == "Start") {
      print("Starting\n");
    }
    else {
      print("Stopping\n");
    }
  }
}


public class ButtonChangeID: Button {
  public ButtonChangeID() { // TODO get status to disable / enable
    this.set_label("Change ID");
    this.set_size_request(button_size_x, button_size_y);
    this.clicked.connect(on_click_changeid);
  }

  private void on_click_changeid() {
    print("Changing id\n");
  }
}


public class ButtonRestart: Button {
  public ButtonRestart() { // TODO get status to disable / enable
    this.set_label("Restart");
    this.set_size_request(button_size_x, button_size_y);
    this.clicked.connect(on_click_restart);
  }

  private void on_click_restart() {
    print("Restarting\n");
  }
}


public class ButtonMyIP: Button {
  public ButtonMyIP() {
    this.set_label("My IP");
    this.set_size_request(button_size_x, button_size_y);
    this.clicked.connect(on_click_myip);
  }

  private void on_click_myip() {
    print("Checking Public IP\n");
  }
}


public class ButtonBootAction: Button {
  public ButtonBootAction(bool is_enabled) {
    if (is_enabled == true) {
      this.set_label("Disable");
    }
    else {
      this.set_label("Enable");
    }

    this.set_size_request(button_boot_size_x, button_boot_size_y);
    this.clicked.connect(on_click_boot_action);
  }

  private void on_click_boot_action() {
    if (this.get_label() == "Enable") {
      print("Enabling boot\n");
    }
    else {
      print("Disabling boot\n");
    }
  }
}


public class ImageAnonSurfStatus: Image {
  public ImageAnonSurfStatus() { // TODO get status
    this.set_from_icon_name("security-medium", DIALOG);
  }
}


public class MainLayout: Box {
  public Label label_boot_status;
  public Label label_anonsurf_status;
  public Button button_anonsurf_actions; // Start or Stop anonsurf
  public Button button_change_id;
  public Button button_my_ip;
  public Button button_restart;
  public Button button_boot_actions;
  public Image image_status;

  private Box box_detail_area;
  private Box box_button_area;

  private Frame frame_boot_area;


  public MainLayout() {
    GLib.Object(orientation: Orientation.HORIZONTAL);
    // Template variables. TODO use parser and refesher for this
    bool boot_status = false;
    // End of tmp variables

    label_boot_status = new LabelBootStatus(false);
    label_anonsurf_status = new LabelAnonSurfStatus();
    button_anonsurf_actions = new ButtonAnonSurfAction();
    button_change_id = new ButtonChangeID();
    button_restart = new ButtonRestart();
    button_boot_actions = new ButtonBootAction(boot_status);
    button_my_ip = new ButtonMyIP();
    image_status = new ImageAnonSurfStatus();

    init_all_objects();

    var box_extra_details = new Box(Orientation.VERTICAL, 3);

    box_extra_details.pack_start(box_detail_area, true, true, 3);
    box_extra_details.pack_start(frame_boot_area, false, true, 3);

    this.pack_start(box_extra_details, false, true, 3);
    this.pack_start(box_button_area, false, true, 1);
  }

  private void init_all_objects() {
    init_detail_area();
    init_boot_area();
    init_button_area();
  }

  private void init_detail_area() {
    box_detail_area = new Box(Orientation.HORIZONTAL, 3);

    box_detail_area.pack_start(image_status, false, true, 3);
    box_detail_area.pack_start(label_anonsurf_status, false, true, 3);
  }

  private void init_boot_area() {
    var box_boot_area = new Box(Orientation.HORIZONTAL, 3);
    frame_boot_area = new Frame("Boot status");

    box_boot_area.pack_start(label_boot_status, false, true, 3);
    box_boot_area.pack_start(button_boot_actions, false, true, 3);

    frame_boot_area.add(box_boot_area);
  }

  private void init_button_area() {
    box_button_area = new Box(Orientation.VERTICAL, 3);

    var box_button_upper = new Box(Orientation.HORIZONTAL, 3);
    var box_button_lower = new Box(Orientation.HORIZONTAL, 3);

    box_button_upper.pack_start(button_anonsurf_actions, false, true, 3);
    box_button_upper.pack_start(button_restart, false, true, 3);
    box_button_lower.pack_start(button_change_id, false, true, 3);
    box_button_lower.pack_start(button_my_ip, false, true, 3);

    box_button_area.pack_start(box_button_upper, false, true, 3);
    box_button_area.pack_start(box_button_lower, false, true, 3);
  }
}
