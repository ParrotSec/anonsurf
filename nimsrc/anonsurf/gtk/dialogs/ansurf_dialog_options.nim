import gintro / [gtk, gobject]
import .. / gui_activities / dialog_options
import .. / gui_activities / core_activities
import .. / .. / options / [option_handler, option_objects]


proc initOptionBridge(cb: ComboBoxText, active: int) =
  cb.appendText("No Bridge")
  cb.appendText("Auto")
  cb.appendText("Manual")
  cb.active = active 


proc initEntryBridge(en: Entry, bridge_addr: string, bridge_mode: int) =
  en.setPlaceholderText("obfs4 proxy address")
  en.setTooltipText("obfs4 <IP>:<port> [A-Z\\d]{40} cert=[\\w\\d\\+\\/]{70} iat-mode=[\\d]")
  # obfs4 (?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?)(?::\d{0,5})? [A-Z\d]{40} cert=[\w\d\+\/]{70} iat-mode=[\d]
  en.setText(bridge_addr)
  if bridge_mode == 2:
    en.setSensitive(true)
  else:
    en.setSensitive(false)


proc initOptionSandbox(cb: CheckButton, set_sandbox: bool) =
  cb.setTooltipText("Only work without bridge")
  cb.setActive(set_sandbox)


proc initBoxButtons(bA, bC: Button, d: Dialog, opt1: ComboBoxText, opt2: Entry, opt3: CheckButton): Box =
  let
    area = newBox(Orientation.horizontal, 3)
    config = ApplyConfigObj(
      bridgeOption: opt1,
      bridgeAddr: opt2,
      sandboxMode: opt3,
    )

  area.packStart(bA, true, false, 3)
  area.packEnd(bC, true, false, 3)
  bA.connect("clicked", onClickApplyConfig, config)
  bC.connect("clicked", onClickCancel, d)
  opt1.connect("changed", onClickBridgeMode, opt2)

  return area


proc initDialogArea(b: Box, opt1: ComboBoxText, opt2: Entry, opt3: CheckButton, btn1, btn2: Button, d: Dialog) =
  b.add(opt1)
  b.add(opt2)
  b.add(opt3)
  b.packStart(initBoxButtons(btn1, btn2, d, opt1, opt2, opt3), true, false, 3)
  discard


proc initDialogSettings(d: Dialog) =
  d.setTitle("AnonSurf Settings")
  d.setIconName("preferences-desktop")
  d.showAll()


proc onClickOptions*(b: Button) =
  let
    ansurfConfig = ansurf_options_handle_load_config()
    dialogSettings = newDialog()
    dialogArea = dialogSettings.getContentArea()
    optionBridge = newComboBoxText()
    addrBridge = newEntry()
    optionSandbox = newCheckButton("Sandbox mode")
    # optionBlockInbound = newCheckButton("Block Inbound traffic")
    # optionBypassFirewall = newCheckButton("Bypass NetworkFirewall")
    buttonApply = newButton("Apply")
    buttonCancel = newButton("Cancel")

  initOptionBridge(optionBridge, int(ansurfConfig.option_bridge_mode))
  initEntryBridge(addrBridge, ansurfConfig.option_bridge_address, int(ansurfConfig.option_bridge_mode))
  initOptionSandbox(optionSandbox, ansurfConfig.option_sandbox)

  dialogArea.initDialogArea(optionBridge, addrBridge, optionSandbox, buttonApply, buttonCancel, dialogSettings)
  dialogSettings.initDialogSettings()

  discard dialogSettings.run()
  ansurf_gtk_close_dialog(dialogSettings)
