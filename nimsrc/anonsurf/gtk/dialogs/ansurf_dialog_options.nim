import gintro / [gtk, gobject]
import .. / gui_activities / core_activities
import .. / .. / options / option_handler


proc initOptionBridge(cb: ComboBoxText, active: int) =
  cb.appendText("No Bridge")
  cb.appendText("Automation")
  cb.appendText("Manual")
  cb.active = active 


proc initEntryBridge(en: Entry, bridge_addr: string) =
  en.setPlaceholderText("Bridge address")
  en.setTooltipText("We should put format here?")
  en.setText(bridge_addr)


proc initOptionSandbox(cb: CheckButton, set_sandbox: bool) =
  cb.setTooltipText("Only work without bridge")
  cb.setActive(set_sandbox)


# proc initOptionBlockInbound(cb: CheckButton) =
#   cb.setTooltipText("Block all inbound traffic when AnonSurf is on")


proc onClickCancel(b: Button, d: Dialog) =
  ansurf_gtk_close_dialog(d)


proc initBoxButtons(bA, bC: Button, d: Dialog): Box =
  let
    area = newBox(Orientation.horizontal, 3)

  area.packStart(bA, true, false, 3)
  area.packEnd(bC, true, false, 3)
  bC.connect("clicked", onClickCancel, d)

  return area


proc initDialogArea(b: Box, opt1: ComboBoxText, opt2: Entry, opt3: CheckButton, btn1, btn2: Button, d: Dialog) =
  b.add(opt1)
  b.add(opt2)
  b.add(opt3)
  b.packStart(initBoxButtons(btn1, btn2, d), true, false, 3)
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
  initEntryBridge(addrBridge, ansurfConfig.option_bridge_address)
  initOptionSandbox(optionSandbox, ansurfConfig.option_sandbox)

  dialogArea.initDialogArea(optionBridge, addrBridge, optionSandbox, buttonApply, buttonCancel, dialogSettings)
  dialogSettings.initDialogSettings()

  discard dialogSettings.run()
  ansurf_gtk_close_dialog(dialogSettings)
