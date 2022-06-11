import gintro / gtk
import .. / gui_activities / core_activities
import .. / .. / options / option_objects


type
  ApplyConfigObj* = object
    bridgeOption*: ComboBoxText
    bridgeAddr*: Entry
    sandboxMode*: CheckButton


proc onClickApplyConfig*(b: Button, c: ApplyConfigObj) =
  let config = SurfConfig(
    option_sandbox: c.sandboxMode.getActive(),
    option_bridge_mode: cast[BridgeMode](c.bridgeOption.getActive()),
    option_bridge_address: c.bridgeAddr.getText(),
  )
  ansurf_gtk_save_config(config)


proc onClickBridgeMode*(c: ComboBoxText, e: Entry) =
  if c.getActive == 2:
    e.setSensitive(true)
  else:
    e.setSensitive(false)


proc onClickCancel*(b: Button, d: Dialog) =
  ansurf_gtk_close_dialog(d)
