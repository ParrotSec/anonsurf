using Gtk;


public class MainLayout: Box {
  public Label label_anonsurf_status;
  public Label label_boot_status;
  public Button button_anonsurf_actions; // Start or Stop anonsurf
  public Button button_change_id;
  public Button button_my_ip;
  public Button button_boot_actions;
  public Button button_restart;
  public Image image_status;

  private Box box_detail_area;
  private Box box_button_area;

  private Frame frame_boot_area;

  const uchar button_size_x = 80;
  const uchar button_size_y = 70;


  public MainLayout() {
    GLib.Object(orientation: Orientation.HORIZONTAL);

    init_detail_area();
    init_boot_area();
    init_button_area();

    var box_extra_details = new Box(Orientation.VERTICAL, 3);

    box_extra_details.pack_start(box_detail_area, true, true, 3);
    box_extra_details.pack_start(frame_boot_area, false, true, 3);

    this.pack_start(box_extra_details, false, true, 3);
    this.pack_start(box_button_area, false, true, 1);
  }


  private void init_detail_area() {
    image_status = new Image.from_icon_name("security-medium", DIALOG);
    label_anonsurf_status = new Label.with_mnemonic("Disabled");
    box_detail_area = new Box(Orientation.HORIZONTAL, 3);

    box_detail_area.pack_start(image_status, false, true, 3);
    box_detail_area.pack_start(label_anonsurf_status, false, true, 3);
  }


  private void init_boot_area() {
    label_boot_status = new Label.with_mnemonic("Not enabled");
    button_boot_actions = new Button.with_label("Enable");
    frame_boot_area = new Frame("Boot status");

    var box_boot_area = new Box(Orientation.HORIZONTAL, 3);

    box_boot_area.pack_start(label_boot_status, false, true, 3);
    box_boot_area.pack_start(button_boot_actions, false, true, 3);
    button_boot_actions.set_size_request(60, 48);

    //  frame_boot_area.set_label_align(0.0f, 0.0f); Seems like this is broken
    frame_boot_area.add(box_boot_area);
  }


  private void init_button_area() {
    button_anonsurf_actions = new Button.from_icon_name("media-playback-start");
    button_restart = new Button.from_icon_name("system-restart-panel");
    button_change_id = new Button.with_label("Change ID");
    button_my_ip = new Button.with_label("My IP");
    box_button_area = new Box(Orientation.VERTICAL, 3);

    var box_button_upper = new Box(Orientation.HORIZONTAL, 3);
    var box_button_lower = new Box(Orientation.HORIZONTAL, 3);

    button_anonsurf_actions.set_size_request(button_size_x, button_size_y);
    button_restart.set_size_request(button_size_x, button_size_y);
    button_change_id.set_size_request(button_size_x, button_size_y);
    button_my_ip.set_size_request(button_size_x, button_size_y);

    box_button_upper.pack_start(button_anonsurf_actions, false, true, 3);
    box_button_upper.pack_start(button_restart, false, true, 3);
    box_button_lower.pack_start(button_change_id, false, true, 3);
    box_button_lower.pack_start(button_my_ip, false, true, 3);

    box_button_area.pack_start(box_button_upper, false, true, 3);
    box_button_area.pack_start(box_button_lower, false, true, 3);
  }
}
