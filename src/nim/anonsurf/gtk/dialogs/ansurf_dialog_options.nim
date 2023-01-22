import gintro / [gtk, gobject]
import .. / gui_activities / dialog_options
import .. / gui_activities / core_activities
import .. / .. / options / [option_handler, option_objects]
import .. / ansurf_gtk_objects
import .. / .. / cores / handle_activities


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


proc initBoxButtons(bA, bC: Button, d: Dialog, optionBridge, optionPlainPort: ComboBoxText,
  addrBridge: Entry, optionSandbox, optionSafeSock: CheckButton, callback: proc): Box =
  let
    area = newBox(Orientation.horizontal, 3)
    config = ApplyConfigObj(
      bridgeOption: optionBridge,
      bridgeAddr: addrBridge,
      sandboxMode: optionSandbox,
      safeSock: optionSafeSock,
      plainPortMode: optionPlainPort,
      callback_show_error: callback
    )
    args = ClickApplyArgs(
      configs: config,
      dialog: d
    )

  area.packStart(bA, true, false, 3)
  area.packEnd(bC, true, false, 3)
  bA.connect("clicked", onClickApplyConfig, args)
  bC.connect("clicked", onClickCancel, d)
  optionBridge.connect("changed", onClickBridgeMode, addrBridge)

  return area


proc initOptionPlainPort(opt: ComboBoxText, i: int) =
  opt.appendText("Warn plain ports")
  opt.appendText("Reject plain ports")
  opt.setActive(i)


proc initOptionSafeSock(opt: CheckButton, set_active: bool) =
  opt.setActive(set_active)


proc initDialogArea(b: Box, optionBridge, optionPlainPort: ComboBoxText, addrBridge: Entry,
  optionSandbox, optionSafeSock: CheckButton, btn1, btn2: Button, d: Dialog, callback: proc) =
  b.add(optionPlainPort)
  b.add(optionBridge)
  b.add(addrBridge)
  b.add(optionSafeSock)
  b.add(optionSandbox)
  b.packStart(initBoxButtons(btn1, btn2, d, optionBridge, optionPlainPort, addrBridge, optionSandbox, optionSafeSock, callback), true, false, 3)


proc initDialogSettings(d: Dialog) =
  d.setTitle("AnonSurf Settings")
  d.setIconName("preferences-desktop")
  d.setResizable(false)
  d.showAll()


proc onClickOptions*(b: Button) =
  let
    ansurfConfig = ansurf_options_handle_load_config()
    dialogSettings = newDialog()
    dialogArea = dialogSettings.getContentArea()
    optionBridge = newComboBoxText()
    optionPlainPort = newComboBoxText()
    optionSafeSock = newCheckButton("Safe Sock protocol")
    addrBridge = newEntry()
    optionSandbox = newCheckButton("Sandbox mode")
    # optionBlockInbound = newCheckButton("Block Inbound traffic")
    # optionBypassFirewall = newCheckButton("Bypass NetworkFirewall")
    buttonApply = newButton("Apply")
    buttonCancel = newButton("Cancel")
    callback_send_msg = cli_init_callback_msg(true)

  initOptionPlainPort(optionPlainPort, int(ansurfConfig.option_plain_port))
  initOptionSafeSock(optionSafeSock, ansurfConfig.option_safe_sock)
  initOptionBridge(optionBridge, int(ansurfConfig.option_bridge_mode))
  initEntryBridge(addrBridge, ansurfConfig.option_bridge_address, int(ansurfConfig.option_bridge_mode))
  initOptionSandbox(optionSandbox, ansurfConfig.option_sandbox)

  dialogArea.initDialogArea(optionBridge, optionPlainPort, addrBridge, optionSandbox, optionSafeSock, buttonApply, buttonCancel, dialogSettings, callback_send_msg)
  dialogSettings.initDialogSettings()

  discard dialogSettings.run()
  ansurf_gtk_close_dialog(dialogSettings)
