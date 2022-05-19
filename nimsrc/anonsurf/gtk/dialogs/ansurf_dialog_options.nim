import gintro / gtk


proc initOptionBridge(cb: ComboBoxText, active: int) =
  cb.appendText("No Bridge")
  cb.appendText("Automation")
  cb.appendText("Manual")
  cb.active = active 


proc initEntryBridge(en: Entry) =
  en.setPlaceholderText("Bridge address")
  en.setTooltipText("We should put format here?")


proc initOptionSandbox(cb: CheckButton) =
  cb.setTooltipText("Only work without bridge")


proc initOptionBlockInbound(cb: CheckButton) =
  cb.setTooltipText("Block all inbound traffic when AnonSurf is on")


proc onClickOptions*(b: Button) =
  let
    dialogSettings = newDialog()
    dialogArea = dialogSettings.getContentArea()
    optionBridge = newComboBoxText()
    addrBridge = newEntry()
    optionSandbox = newCheckButton("Sandbox mode")
    optionBlockInbound = newCheckButton("Block Inbound traffic")

  initOptionBridge(optionBridge, 0) # TODO load active number from settings instead
  initEntryBridge(addrBridge)
  initOptionSandbox(optionSandbox)
  initOptionBlockInbound(optionBlockInbound)

  dialogArea.add(optionBridge)
  dialogArea.add(addrBridge)
  dialogArea.add(optionSandbox)

  dialogSettings.setTitle("AnonSurf Settings")
  dialogSEttings.setIconName("preferences-desktop")

  dialogSettings.showAll()
  discard dialogSettings.run()
  dialogSettings.destroy()
